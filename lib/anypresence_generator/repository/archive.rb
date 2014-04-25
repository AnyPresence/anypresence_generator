require 'open-uri'
require "anypresence_generator/repository/git"

module AnypresenceGenerator
  module Repository
    class Archive < ::AnypresenceGenerator::Repository::Git

      def clone(recursive: false)
        init

        git_archive = Tempfile.new(['git_archive','.zip'])
        git_archive.close

        File.open(File.path(git_archive), "wb") do |archive_file|
          open(git_url, "rb") do |remote_file|
            archive_file.write(remote_file.read)
          end
        end
        last_output = %x|tar -xf "#{File.path(git_archive)}" -C "#{directory}" 2>&1|

        unless $?.success?
          raise ::AnypresenceGenerator::Repository::Git::GitError.new("Git archive clone failed with exit code: #{$?}\n#{last_output}")
        end

        if recursive
          Bundler.with_clean_env do
            Dir.chdir(@git.dir.to_s) do
              last_output = %x|git submodule update --init --recursive 2>&1|

              unless $?.success?
                raise ::AnypresenceGenerator::Repository::Git::GitError.new("Git archive submodule update failed with exit code: #{$?}\n#{last_output}")
              end
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
            gitignore.split("\n").each { |ignore| exclude << %|--exclude="./#{ignore.start_with?('/') ? ignore.sub('/','') : ignore}" | unless ignore.start_with?('#') }
            last_output = %x|tar -cvzf "#{archive_source.path}" -C "#{directory}" #{exclude} "." 2>&1|
          else
            last_output = %x|tar -cvzf "#{archive_source.path}" -C "#{directory}" "." 2>&1|
          end
          unless $?.success?
            raise ::AnypresenceGenerator::Repository::Git::GitError.new("Git archiving failed with exit code: #{$?}\n#{last_output}")
          end
          RestClient.post( git_url, File.open(archive_source), multipart: true, content_type: 'application/zip' ) unless mock
          FileUtils.cp(File.path(archive_source), "#{directory}/git_archive.zip")
        end
      end
    end
  end
end