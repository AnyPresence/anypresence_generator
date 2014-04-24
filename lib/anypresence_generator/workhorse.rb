require 'tempfile'
require 'rest-client'
require 'anypresence_generator/command'
require 'anypresence_generator/log'
require 'anypresence_generator/repository'
require 'anypresence_generator/payload'

module AnypresenceGenerator
  class Workhorse
    include AnypresenceGenerator::Command
    include AnypresenceGenerator::Log
    include AnypresenceGenerator::Repository
    include AnypresenceGenerator::Payload
    class WorkableError < StandardError; end

    attr_accessor :mock, :auth_token, :project_directory

    class << self
      attr_accessor :_steps

      def steps(*steps)
        if self._steps.nil? || self._steps.blank?
          self._steps = steps
        else
          self._steps.push(steps)
        end
      end
    end

    def initialize(json_payload: nil, auth_token: ( raise WorkableError.new('No Auth token provided.'.freeze) ), sensitive_values: {}, mock: false)
      steps.each { |step| raise WorkableError.new("No method named '#{step.to_s}' in this class.") unless respond_to?(step) }
      self.digest(json_payload: json_payload)
      self.mock = mock
      self.auth_token = auth_token
      self.sensitive_values = sensitive_values
      self.log_file = Tempfile.new(['logfile'.freeze,'txt'.freeze])
    end

    def work
      steps.each do |step|
        increment_step! step
        self.send(step)
      end
    end

    def start!
      Dir.mktmpdir do |dir|
        begin
          self.project_directory = File.join(dir, build.id.to_s)
          FileUtils.mkdir_p(project_directory)
          setup_repository
          work
          success! "Completed work!".freeze
          return true
        rescue
          error! "Process has failed with the following error: #{$!.message}"
          return false
        ensure
          log "Deleting temporary files".freeze
          begin
            FileUtils.remove_entry project_directory
          rescue
            log "Exception deleting file '#{dir.path}': #{$!.message}"
          end
        end
      end
    end

    def run_generators(*generators)
      generators.each do |generator|
        generator.write!(project_dir)
        yield "#{project_dir}/#{generator.filename}" if block_given?
      end
    end

    def error!(message)
      log "Error: #{message}"
      RestClient.put( build.error_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock
    end

    def success!(message)
      log "Success: #{message}"
      RestClient.put( build.success_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock
    end

    def increment_step!(step)
      log "Incrementing step to #{step}..."
      RestClient.put( build.increment_step_url, { step: step }.to_json, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock
    end

    private

    def steps
      self.class._steps
    end
  end
end
