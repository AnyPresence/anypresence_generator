module AnypresenceGenerator
  module Log
    attr_accessor :log_file, :log_to_stdout, :log_timestamps

    def log(message, extra_line: false)
      puts(message) if log_to_stdout
      log ||= ""
      log << Time.now.to_s << ": " if log_timestamps
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