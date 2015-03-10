require 'bundler'

module AnypresenceGenerator
  module Repository
    class Git
      class GitError < StandardError; end

      attr_accessor :workhorse, :user_name, :user_email, :git_url, :directory, :pushed, :mock, :max_network_retry

      def initialize( workhorse: , repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), user_name:, user_email:, mock: false, max_network_retry: )
        self.workhorse = workhorse
        self.git_url = repository_payload.url
        self.directory = directory
        self.user_name = user_name
        self.user_email = user_email
        self.pushed = repository_payload.pushed
        self.mock = mock
        self.max_network_retry = max_network_retry
      end

      def init
        workhorse.run_command(%|cd #{directory} && git init|, silence: true)
        workhorse.run_command(%|cd #{directory} && git remote add origin #{git_url}|) if git_url
      end

      def clone(recursive: false)
        workhorse.run_command(%|cd #{directory} && git clone #{git_url} .|, silence: true)
        workhorse.run_command(%|cd #{directory} && git submodule update --init --recursive|, silence: true) if recursive
      end

      def commit(commit_message: nil)
        workhorse.run_command(%|cd #{directory} && git config --local user.name "#{user_name}"|, silence: true)
        workhorse.run_command(%|cd #{directory} && git config --local user.email "#{user_email}"|, silence: true)
        workhorse.run_command(%|cd #{directory} && git add --all -- "."|, silence: true)
        workhorse.run_command(%|cd #{directory} && git commit -m "#{commit_message}"|, silence: true)
      end

      def push(remote_name: nil, remote_url: nil)
        unless mock
          if remote_name
            workhorse.run_command(%|cd #{directory} && git remote add #{remote_name} #{remote_url}|)
            workhorse.run_command(%|cd #{directory} && git push #{remote_name} master|)
          else
            workhorse.run_command(%|cd #{directory} && git push origin master|)
          end
        end
      end

      def add_submodule(local: nil, remote: nil, branch: 'master')
        workhorse.run_command(%|cd #{directory} && git submodule deinit --force "#{local}"|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && git rm --force "#{local}"|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && git rm --cached "#{local}"|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && git config -f .gitmodules --remove-section submodule."#{local}"|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && git config -f .git/config --remove-section submodule."#{local}"|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && rm -Rf .git/modules/#{local}|, abort: false, silence: true)
        workhorse.run_command(%|cd #{directory} && git submodule add -b "#{branch}" --force "#{remote}" "#{local}"|)
      end
    end
  end
end
