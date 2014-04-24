require 'bundler'

module AnypresenceGenerator
  module Command

    attr_accessor :sensitive_values

    def run_command(command_string, abort: true, silence: false, filter: nil)

      filtered_command = command_string.clone
      sensitive_values.each do |sensitive, filtered|
        filtered_command.gsub! sensitive, filtered
      end

      log filtered_command, timestamp: false unless silence
      last_output = nil
      Bundler.with_clean_env do
        last_output = `#{command_string} 2>&1`
      end
      filtered_output = nil
      if !silence && filter && filter.is_a?(Regexp)
        result = last_output.each_line.select { |line| line if line =~ filter }
        filtered_output = result.join("\n")
      end

      unless silence
        output = filtered_output || last_output
        log output
      end

      if 0 != $?.to_i
        if abort
          raise ::AnypresenceGenerator::Workhorse::WorkableError.new("command failed with exit code #{$?}")
        elsif !silence
          log "#{$?}, aborting"
        end
      else
        last_output
      end
    end
  end
end