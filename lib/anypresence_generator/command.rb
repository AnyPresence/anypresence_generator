module AnypresenceGenerator
  module Command
    include ::AnypresenceGenerator::Log
    def run_command(command_string, options={})
      abort = options[:abort].nil? ? true : options[:abort]

      filtered_command = command_string.clone
      @sensitive_values ||= {}
      @sensitive_values.each do |sensitive, filtered|
        filtered_command.gsub! sensitive, filtered
      end

      log filtered_command, :timestamp => false unless options[:silence]
      @last_output = `#{command_string} 2>&1`
      filtered_output = nil
      if !options[:silence] && options[:filter] && options[:filter].is_a?(Regexp)
        res = @last_output.each_line.select { |line| line if line =~ options[:filter] }
        filtered_output = res.join("\n")
      end

      if !options[:silence]
        output = filtered_output || @last_output
        log_output output
      end

      if 0 != $?.to_i
        if abort
          raise ::AnypresenceGenerator::Workhorse::WorkableError.new("command failed with exit code #{$?}")
        elsif !options[:silence]
          log "#{$?}, aborting"
        end
      else
        @last_output
      end
    end
  end
end