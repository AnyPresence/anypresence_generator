module AnypresenceGenerator
  module Log
    attr_accessor :log_file

    def log(message, stdout: false, timestamp: false, extra_line: false)
      puts(message) if stdout
      log ||= ""
      log << Time.now.to_s << ": " if timestamp
      log << message.to_s << "\n"
      log << "\n" if extra_line
      File.open(log_file.path, 'a'.freeze) do |file|
        file.puts(log)
        file.close
      end
      log
    end

    def log_content
      "\n" + File.read(log_file.path)
    end

  end
end