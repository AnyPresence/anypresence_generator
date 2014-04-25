require 'git'
require 'bundler'

module AnypresenceGenerator
  module Repository
    class Git
      class GitError < StandardError; end

      attr_accessor :git, :removed_directories, :removed_files, :git_url, :directory, :pushed, :mock

      def initialize( repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), mock: false )
        self.git_url = repository_payload.url
        self.directory = directory
        self.pushed = repository_payload.pushed
        self.mock = mock
      end

      def init
        self.git = ::Git.init(directory)
      end

      def clone(recursive: false)
        self.git = ::Git.clone(git_url, '', path: directory)

        if recursive
          Bundler.with_clean_env do
            Dir.chdir(git.dir.to_s) do
              last_output = %x|git submodule update --init --recursive 2>&1|
              unless $?.success?
                raise ::AnypresenceGenerator::Repository::Git::GitError.new("Git submodule update failed with exit code: #{$?}\n#{last_output}")
              end
            end
          end
        end
      end

      def remove_directory(removed_directory)
        self.removed_directories ||= []
        if File.directory?(removed_directory)
          self.removed_directories << removed_directory
          FileUtils.rm_rf(removed_directory)
        end
      end

      def remove_file(file)
        self.removed_files ||= []
        if File.exists?(file)
          self.removed_files << file
          FileUtils.rm_rf(file)
        end
      end

      def commit(user_name: nil, user_email: nil, commit_message: nil)
        git.config('user.name', user_name)
        git.config('user.email', user_email)
        git.remove(removed_files) unless removed_files.nil? || removed_files.empty?
        git.remove(removed_directories, recursive: true) unless removed_directories.nil? || removed_directories.empty?
        if (!pushed && !%x|ls #{directory}|.empty?) || (pushed && !git.status.changed.empty?)
          git.add '.'
          git.commit_all commit_message
        end
        removed_files.clear unless removed_files.nil? || removed_files.empty?
        removed_directories.clear unless removed_directories.nil? || removed_directories.empty?
      end

      def push(remote: nil)
        unless mock
          if remote
            git.add_remote(remote, git_url)
            git.push(git.remote(remote))
          else
            git.push git_url
          end
        end
      end

      def add_submodule(local: nil, remote: nil, branch: 'master')
        Bundler.with_clean_env do
          Dir.chdir(git.dir.to_s) do
            %x|git submodule deinit --force "#{local}"|
            %x|git rm --force "#{local}"|
            %x|git config -f .gitmodules --remove-section submodule."#{local}"|
            %x|rm -Rf .git/modules/#{local}|

            last_output = %x|git submodule add -b "#{branch}" --force "#{remote}" "#{local}" 2>&1|

            unless $?.success?
              raise ::AnypresenceGenerator::Repository::Git::GitError.new("Git submodule add #{remote} failed with exit code: #{$?}\n#{last_output}")
            end
          end
        end
      end
    end
  end
end
