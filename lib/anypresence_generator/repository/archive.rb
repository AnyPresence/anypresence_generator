require 'open-uri'
require "anypresence_generator/repository/git"
require 'anypresence_generator/utils/wrap_calls'

module AnypresenceGenerator
  module Repository
    class Archive < ::AnypresenceGenerator::Repository::Git
      include AnypresenceGenerator::Utils::WrapCalls

      attr_accessor :readable_git_url, :writeable_git_url

      def initialize( workhorse: , repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), user_name:, user_email:, mock: false, max_network_retry: )
        self.readable_git_url = repository_payload.readable_url
        self.writeable_git_url = repository_payload.writeable_url
        super
      end

      def clone(recursive: false)
        init

        git_archive = Tempfile.new(['git_archive','.zip'])
        git_archive.close

        File.open(File.path(git_archive), "wb") do |archive_file|
          open(readable_git_url, "rb") do |remote_file|
            archive_file.write(remote_file.read)
          end
        end
        if (workhorse.run_command(%|file -Ib #{File.path(git_archive)}|, silence: true).first.start_with?("application/zip;".freeze))
          workhorse.run_command(%|cd #{directory} && unzip -o #{File.path(git_archive)}|, silence: true)
        else
          workhorse.run_command(%|tar -xf "#{File.path(git_archive)}" -C "#{directory}"|, silence: true)
        end
        workhorse.run_command(%|cd #{directory} && git submodule update --init --recursive|) if recursive
      end

      def push(remote: nil)
        if remote
          super
        else
          archive_source = Tempfile.new(['git_archive','.zip'])
          archive_source.close
          FileUtils.rm(archive_source)
          if File.exists?("#{directory}/.gitignore")
            gitignore = File.read("#{directory}/.gitignore")
            exclude = ""
            gitignore.split("\n").each { |ignore| exclude << %|--exclude="./#{ignore.start_with?('/') ? ignore.sub('/','') : ignore}*" | if !ignore.start_with?('#') && !ignore.nil? && !ignore.blank? }
            workhorse.run_command(%|cd #{directory} && zip -r #{archive_source.path} . #{exclude}|, silence: true)
          else
            workhorse.run_command(%|cd #{directory} && zip -r #{archive_source.path} .|, silence: true)
          end
          with_retry(max_network_retry) { RestClient.put( writeable_git_url, File.open(archive_source), multipart: true, content_type: 'application/zip' ) unless mock }
          FileUtils.cp(File.path(archive_source), "#{directory}/git_archive.zip")
        end
      end
    end
  end
end
