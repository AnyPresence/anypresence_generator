require 'bundler'

module AnypresenceGenerator
  module Command

    attr_accessor :sensitive_values

    def run_command(command_string, abort: true, silence: false, filter: nil, streaming: true)
      filtered_command = command_string.clone
      sensitive_values.each do |sensitive, filtered|
        filtered_command.gsub! sensitive, filtered
      end

      log filtered_command unless silence

      command_output = ""
      Bundler.with_clean_env do
        if streaming
          IO.popen("#{command_string} 2>&1") do |io|
            until io.eof?
              buffer = io.gets
              command_output << handle_command_output(buffer, abort, silence, filter)
            end
          end
          output_or_abort("", abort, silence)
        else
          last_output = `#{command_string} 2>&1`
          command_output << handle_command_output(last_output, abort, silence, filter)
        end
      end
      command_output
    end
    
    private 
    
    def handle_command_output(last_output, abort, silence, filter)
      filtered_output = nil
      if !silence && filter && filter.is_a?(Regexp)
        result = last_output.each_line.select { |line| line if line =~ filter }
        filtered_output = result.join("\n")
      end

      unless silence
        output = filtered_output || last_output
        log output
      end
      
      output_or_abort(last_output, abort, silence)
    end
    
    def output_or_abort(output, abort, silence)
      if 0 != $?.exitstatus
        if abort
          raise ::AnypresenceGenerator::Workhorse::WorkableError.new("command failed with exit code #{$?.exitstatus}")
        elsif !silence
          log "#{$?}, aborting"
        end
      else
        output
      end
    end
    
  end
end