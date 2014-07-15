require 'bundler'

module AnypresenceGenerator
  module Command

    attr_accessor :sensitive_values

    def run_command(command_string, abort: true, silence: false, filter: nil)
      filtered_command = command_string.clone
      sensitive_values.each do |sensitive, filtered|
        filtered_command.gsub! sensitive, filtered
      end

      log filtered_command unless silence

      command_output = []
      Bundler.with_clean_env do
        IO.popen("#{command_string} 2>&1") do |io|
          until io.eof?
            buffer = io.gets
            command_output << handle_command_output(buffer.gsub(/\s*$/,''), abort, silence, filter)
          end
          io.close
        end
      end
      if $?.success?
        return command_output.join("\n"), true
      else
        if abort
          raise ::AnypresenceGenerator::Workhorse::WorkableError.new("command failed with exit code #{$?.exitstatus}")
        elsif !silence
          log "#{$?}"
        end
        return command_output.join("\n"), false
      end
    end

    private

    def handle_command_output(last_output, abort, silence, filter)
      filtered_output = nil
      if !silence && filter && filter.is_a?(Regexp)
        result = last_output.each_line.select { |line| line if line =~ filter }
        filtered_output = result.join("\n")
      end

      output = filtered_output || last_output
      log output unless silence || output.nil? || output.blank?
      output
    end

  end
end