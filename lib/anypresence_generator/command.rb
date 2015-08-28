require 'bundler'

module AnypresenceGenerator
  module Command

    attr_accessor :sensitive_values

    REGEXP_COLOR_PATTERN = /\e\[([0-9]+)m(.+?)\e\[0m|([^\e]+)/m

    def run_command(command_string, abort: true, silence: false, delay_logging: false, filter: nil)
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
            command_output << handle_command_output(buffer.gsub(/\s*$/,''), abort, silence, filter, delay_logging)
          end
          io.close
        end
      end
      command_output_flattened = command_output.join("\n")
      if !silence && delay_logging && filter && filter.is_a?(Proc)
        command_output_flattened = filter.call(command_output_flattened)
        log command_output_flattened
      end
      if $?.success?
        return command_output_flattened, true
      else
        if abort
          raise ::AnypresenceGenerator::Workhorse::WorkableError.new("command failed with exit code #{$?.exitstatus}")
        elsif !silence
          log "#{$?}"
        end

        return command_output_flattened, false
      end
    end

    private

    def handle_command_output(last_output, abort, silence, filter, delay_logging)
      filtered_output = nil
      if !silence && filter && filter.is_a?(Regexp)
        result = last_output.each_line.select { |line| line if line =~ filter }
        filtered_output = result.join("\n")
      end

      output = filtered_output || last_output
      output = uncolorize(output)

      log output unless silence || output.nil? || output.blank? || delay_logging
      output
    end

    def uncolorize(colored_str)
      cleaned_str = colored_str.scan(REGEXP_COLOR_PATTERN).inject("") do |str, match|
        str << (match[1] || match[2])
      end
    end

  end
end
