require 'tempfile'
require 'rest-client'
require 'anypresence_generator/command'
require 'anypresence_generator/log'
require 'anypresence_generator/repository'
require 'anypresence_generator/template'
require 'anypresence_generator/utils/wrap_calls'

module AnypresenceGenerator
  class Workhorse
    include AnypresenceGenerator::Command
    include AnypresenceGenerator::Log
    include AnypresenceGenerator::Repository
    include AnypresenceGenerator::Utils::WrapCalls
    class WorkableError < StandardError; end

    attr_accessor :mock, :auth_token, :project_directory, :dump_project_directory, :workable, :raw_payload, :max_network_retry

    class << self
      attr_accessor :_steps, :_error_handler

      def steps(*steps)
        if self._steps.nil? || self._steps.blank?
          self._steps = steps
        else
          self._steps.push(steps)
        end
      end

      def error_handler(method_name)
        self._error_handler = method_name
      end
    end

    def initialize(json_payload: nil, auth_token: ( raise WorkableError.new('No Auth token provided.'.freeze) ), git_user:, git_email:, \
      sensitive_values: {}, mock: false, dump_project_directory: nil, log_to_stdout: false, log_timestamps: false, max_network_retry: nil)
      steps.each { |step| raise WorkableError.new("No method named '#{step.to_s}' in this class.") unless respond_to?(step) }
      raise WorkableError.new("No method named '#{self.class._error_handler}' in this class.") if self.class._error_handler && !respond_to?(self.class._error_handler)
      raise WorkableError.new("Git user and email cannot be nil.") if git_user.nil? || git_email.nil?
      self.raw_payload = json_payload
      self.workable = digest(json_payload: json_payload)
      self.mock = mock
      self.auth_token = auth_token
      self.git_user = git_user
      self.git_email = git_email
      self.sensitive_values = sensitive_values
      self.log_file = Tempfile.new(['logfile'.freeze,'txt'.freeze])
      self.log_to_stdout = log_to_stdout
      self.log_timestamps = log_timestamps
      self.dump_project_directory = dump_project_directory
      self.max_network_retry = max_network_retry
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
          self.project_directory = File.join(dir, workable.id.to_s)
          FileUtils.mkdir_p(project_directory)
          work
          success! "Completed work!".freeze
          return true
        rescue
          error! "Process has failed with the following error: #{$!.message}"
          send(self.class._error_handler, $!) if self.class._error_handler && respond_to?(self.class._error_handler)
          return false
        ensure
          copy_working_directory if dump_project_directory
          log "Deleting temporary files".freeze
          begin
            FileUtils.remove_entry project_directory
          rescue
            log "Exception deleting '#{project_directory}': #{$!.message}"
          end
        end
      end
    end

    def run_templates(*templates)
      templates.each do |template|
        raise WorkableError.new("Not a template!") unless template.is_a?(AnypresenceGenerator::Template)
        template.write!
        yield template.fully_qualified_output_file if block_given?
      end
    end

    def error!(message)
      log "Error: #{message}"
      write_log! rescue nil
      with_retry(max_network_retry) { RestClient.put( workable.error_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock }
    end

    def success!(message)
      log "Success: #{message}"
      write_log!
      with_retry(max_network_retry) { RestClient.put( workable.success_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock }
    end

    def increment_step!(step)
      log "Incrementing step to #{step}..."
      write_log!
      with_retry(max_network_retry) { RestClient.put( workable.increment_step_url, { step: step }.to_json, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock }
    end

    def upload_artifacts
      log 'Creating artifacts archive.'
      artifacts = Tempfile.new(['artifacts','.zip'])
      artifacts.close
      FileUtils.rm(artifacts)
      exclude = "-x "
      %w{.git/* .git/ tmp/* .tmp/* vendor/* .bundle/* node_modules/* git_archive.zip}.each { |ignore| exclude << %|"./#{ignore}" | }
      run_command(%|cd #{project_directory} && zip -r "#{artifacts.path}" . #{exclude}|, silence: true)
      log "Uploading artifacts archive"
      with_retry(max_network_retry) { RestClient.put( workable.writeable_artifact_url, File.open(artifacts), multipart: true, content_type: 'application/zip' ) unless mock }
      with_retry(max_network_retry) { RestClient.put( workable.artifacts_uploaded_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock }
      FileUtils.cp(File.path(artifacts), "#{project_directory}/artifacts.zip")
    end

    def upload_readme
      if File.exists?("#{project_directory}/#{readme_name}")
        log "Uploading #{readme_name}."
        with_retry(max_network_retry) { RestClient.put( workable.writeable_readme_url, File.open("#{project_directory}/#{readme_name}"), multipart: true, content_type: 'text/plain' ) unless mock }
        with_retry(max_network_retry) { RestClient.put( workable.readme_uploaded_url, nil, { authorization: "Token token=\"#{auth_token}\"", content_type: :json, accept: :json } ) unless mock }
      else
        log "No #{readme_name} found, skipping upload."
      end
    end

    private

    def steps
      raise 'Subclasses must implement!'
    end

    def readme_name
      'README.md'.freeze
    end

    def write_log!
      with_retry(max_network_retry) { RestClient.put( workable.writeable_log_url, File.open(log_file), multipart: true, content_type: 'text/plain', content_disposition: 'inline' ) unless mock }
    end

    def copy_working_directory
      FileUtils.rm_rf dump_project_directory
      FileUtils.mkdir_p dump_project_directory
      FileUtils.cp_r "#{project_directory}/.", dump_project_directory
      File.open(File.join(dump_project_directory, "workhorse.log"), 'w') { |file| file.write log_content }
    end
  end
end
