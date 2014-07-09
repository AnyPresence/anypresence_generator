require 'open-uri'
require "anypresence_generator/repository/git"

module AnypresenceGenerator
  module Repository
    class Archive < ::AnypresenceGenerator::Repository::Git

      attr_accessor :readable_git_url, :writeable_git_url

      def initialize( workhorse: , repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), mock: false )
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
        workhorse.run_command(%|tar -xf "#{File.path(git_archive)}" -C "#{directory}"|)

        if recursive
          Bundler.with_clean_env do
            Dir.chdir(@git.dir.to_s) do
              workhorse.run_command(%|git submodule update --init --recursive|)
            end
          end
        end
      end

      def push(remote: nil)
        if remote
          super
        else
          archive_source = Tempfile.new(['git_archive','.zip'])
          archive_source.close
          if File.exists?("#{directory}/.gitignore")
            gitignore = File.read("#{directory}/.gitignore")
            exclude = ""
            gitignore.split("\n").each { |ignore| exclude << %|--exclude="./#{ignore.start_with?('/') ? ignore.sub('/','') : ignore}" | if !ignore.start_with?('#') && !ignore.nil? && !ignore.blank? }
            workhorse.run_command(%|tar -cvzf "#{archive_source.path}" -C "#{directory}" #{exclude} "."|)
          else
            workhorse.run_command(%|tar -cvzf "#{archive_source.path}" -C "#{directory}" "."|)
          end
          RestClient.put( writeable_git_url, File.open(archive_source), multipart: true, content_type: 'application/zip' ) unless mock
          FileUtils.cp(File.path(archive_source), "#{directory}/git_archive.zip")
        end
      end
    end
  end
end