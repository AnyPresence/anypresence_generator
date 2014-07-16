require 'bundler'

module AnypresenceGenerator
  module Repository
    class Git
      class GitError < StandardError; end

      attr_accessor :workhorse, :git_url, :directory, :pushed, :mock

      def initialize( workhorse: , repository_payload: repository_payload, directory: ( raise GitError.new("Directory is required.") ), mock: false )
        self.workhorse = workhorse
        self.git_url = repository_payload.url
        self.directory = directory
        self.pushed = repository_payload.pushed
        self.mock = mock
      end

      def init
        workhorse.run_command(%|cd #{directory} && git init|)
        workhorse.run_command(%|cd #{directory} && git remote add origin #{git_url}|) if git_url
      end

      def clone(recursive: false)
        workhorse.run_command(%|cd #{directory} && git clone #{git_url} .|)
        workhorse.run_command(%|cd #{directory} && git submodule update --init --recursive|) if recursive
      end

      def commit(user_name: nil, user_email: nil, commit_message: nil)
        workhorse.run_command(%|cd #{directory} && git config --local user.name "#{user_name}"|)
        workhorse.run_command(%|cd #{directory} && git config --local user.email "#{user_email}"|)
        workhorse.run_command(%|cd #{directory} && git add --all -- "."|)
        workhorse.run_command(%|cd #{directory} && git commit -m "#{commit_message}"|)
      end

      def push(remote_name: nil, remote_url: nil)
        unless mock
          if remote_name
            run_command(%|cd #{directory} && git remote add #{remote_name} #{remote_url}|)
            run_command(%|cd #{directory} && git push #{remote_name} master|)
          else
            run_command(%|cd #{directory} && git push origin master|)
          end
        end
      end

      def add_submodule(local: nil, remote: nil, branch: 'master')
        workhorse.run_command(%|cd #{directory} && git submodule deinit --force "#{local}" && git rm --force "#{local}" && git config -f .gitmodules --remove-section submodule."#{local}" && rm -Rf .git/modules/#{local}|, abort: false)
        workhorse.run_command(%|cd #{directory} && git submodule add -b "#{branch}" --force "#{remote}" "#{local}"|)
      end
    end
  end
end
