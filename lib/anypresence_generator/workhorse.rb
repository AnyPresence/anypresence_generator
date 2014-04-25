require 'tempfile'
require 'rest-client'
require 'anypresence_generator/command'
require 'anypresence_generator/log'
require 'anypresence_generator/repository'
require 'anypresence_generator/payload'
require 'anypresence_generator/template'

module AnypresenceGenerator
  class Workhorse
    include AnypresenceGenerator::Command
    include AnypresenceGenerator::Log
    include AnypresenceGenerator::Repository
    include AnypresenceGenerator::Payload
    class WorkableError < StandardError; end

    attr_accessor :mock, :auth_token, :project_directory, :dump_project_directory

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

    def initialize(json_payload: nil, auth_token: ( raise WorkableError.new('No Auth token provided.'.freeze) ), git_user: nil, git_email: nil, sensitive_values: {}, mock: false, dump_project_directory: nil)
      steps.each { |step| raise WorkableError.new("No method named '#{step.to_s}' in this class.") unless respond_to?(step) }
      self.digest(json_payload: json_payload)
      self.mock = mock
      self.auth_token = auth_token
      self.git_user = git_user
      self.git_email = git_email
      self.sensitive_values = sensitive_values
      self.log_file = Tempfile.new(['logfile'.freeze,'txt'.freeze])
      self.dump_project_directory = dump_project_directory
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
          work
          success! "Completed work!".freeze
          return true
        rescue
          puts "\n" + $!.message
          puts $!.backtrace
          error! "Process has failed with the following error: #{$!.message}"
          return false
        ensure
          copy_working_directory if dump_project_directory
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
        raise WorkableError.new("Not a template!") unless generator.is_a?(AnypresenceGenerator::Template)
        generator.write!
        yield "#{project_directory}/#{generator.filename}" if block_given?
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
      RestClient.post( build.writeable_log_url, File.open(log_file), multipart: true, content_type: 'text/plain' ) unless mock
      RestClient.put( build.increment_step_url, { step: step }.to_json, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock
    end

    def upload_artifacts
      log 'Creating artifacts archive.'
      artifacts = Tempfile.new(['artifacts','.zip'])
      artifacts.close
      exclude = ""
      %w{.git/ tmp/ vendor/ .bundle/ git_archive.zip}.each { |ignore| exclude << %|--exclude="./#{ignore}" | }
      if run_command(%|tar -cvzf "#{artifacts.path}" -C "#{project_directory}" #{exclude} "."|, silence: true)
        log "Uploading artifacts archive"
        RestClient.post( build.writeable_artifact_url, File.open(artifacts), multipart: true, content_type: 'application/zip' ) unless mock
        FileUtils.cp(File.path(artifacts), "#{project_directory}/artifacts.zip")
      end
    end

    private

    def steps
      [:setup_repository, :init_or_clone] + self.class._steps + [:commit_to_repository, :push_to_repository, :upload_artifacts]
    end

    def copy_working_directory
      FileUtils.rm_rf dump_project_directory
      FileUtils.mkdir_p dump_project_directory
      FileUtils.cp_r "#{project_directory}/.", dump_project_directory
      File.open(File.join(dump_project_directory, "workhorse.log"), 'w') { |file| file.write log_content }
    end
  end
end
