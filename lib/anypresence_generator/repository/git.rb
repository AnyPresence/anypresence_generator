require 'git'
require 'bundler'

module AnypresenceGenerator
  module Repository
    class Git
      class GitError < StandardError; end

      attr_accessor :workhorse, :git, :git_url, :directory, :pushed, :mock

      def initialize( workhorse: , repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), mock: false )
        self.workhorse = workhorse
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

        workhorse.run_command("cd #{git.dir} && git submodule update --init --recursive") if recursive
      end

      def commit(user_name: nil, user_email: nil, commit_message: nil)
        git.config('user.name', user_name)
        git.config('user.email', user_email)
        git.add(all: true)
        git.commit_all commit_message
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
        workhorse.run_command(%|cd #{git.dir} && git submodule deinit --force "#{local}" && git rm --force "#{local}" && git config -f .gitmodules --remove-section submodule."#{local}" && rm -Rf .git/modules/#{local}|, abort: false)
        workhorse.run_command(%|cd #{git.dir} && git submodule add -b "#{branch}" --force "#{remote}" "#{local}"|)
      end
    end
  end
end
