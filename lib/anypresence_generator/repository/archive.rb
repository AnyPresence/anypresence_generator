require "anypresence_generator/repository/git"

module AnypresenceGenerator
  module Repository
    class Archive < ::AnypresenceGenerator::Repository::Git

      def clone(recursive: false)
        init(directory)
        git_archive = archive.to_file
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
          archive_source = Tempfile.new(['archive','.zip'])
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
          self.archive = File.open(archive_source)
          save!
        end
      end
    end
  end
end