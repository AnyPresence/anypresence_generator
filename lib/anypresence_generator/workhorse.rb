require 'json'
require 'recursive-open-struct'

module AnypresenceGenerator
  class Workhorse
    class WorkableError < StandardError; end
    include ::AnypresenceGenerator::Log
    include ::AnypresenceGenerator::Command

    attr_accessor :mock, :payload, :type, :environment, :build, :repository, :api_version, :application_definition

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

    def initialize(json_payload: nil, mock: false)
      steps.each { |step| raise ::AnypresenceGenerator::Workhorse::WorkableError.new("No method named '#{step.to_s}' in this class.") unless respond_to?(step) }
      raise ::AnypresenceGenerator::Workhorse::WorkableError.new('No JSON payload provided.') unless json_payload
      self.mock = mock
      parsed_payload = RecursiveOpenStruct.new(JSON.parse(json_payload), recurse_over_arrays: true)
      [:api, :sdk, :app].each do |type|
        if parsed_payload.send(type)
          self.payload = parsed_payload.send(type)
          self.type = type
        end
      end
      [:environment, :build, :repository, :api_version, :application_definition].each do |attribute|
        self.send( "#{attribute}=", payload.send(attribute) )
      end
    end

    def work
      steps.each do |step|
        increment_step! step
        self.send(step)
      end
    end

    def execute
      Dir.mktmpdir do |dir|
        begin
          @dir = dir
          @project_dir = File.join(@dir, @workable.id.to_s)
          FileUtils.mkdir_p(@project_dir)
          work
          log "Completed work!".freeze
          success!
        rescue ::AnypresenceGenerator::Workhorse::WorkableError
          log "Process has failed with the following error: #{$!.message}"
          error!
        ensure
          log "Deleting temporary files".freeze
          begin
            FileUtils.remove_entry @dir
          rescue
            log "Exception deleting file '#{@dir.path}': #{$!.message}"
          end
        end
      end
    end

    def error!
      
    end

    def success!
      
    end

    def increment_step!(step)
      
    end

    private

    def steps
      self.class._steps
    end
  end
end
