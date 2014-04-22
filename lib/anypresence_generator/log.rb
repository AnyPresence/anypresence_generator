module AnypresenceGenerator
  module Log
    def log(message, options={})
      puts(message) if @options[:stdout]
      @log ||= ""
      @log << Time.now.to_s << ": " unless options[:timestamp] == false
      @log << message.to_s << "\n"
      @log << "\n" if options[:extra_line]
    end

    def log_output(output)
      output = "[no output]" if output.blank?
      log output, :timestamp => false, :extra_line => true
    end

    def debug(message)
      puts message
    end
  end
end