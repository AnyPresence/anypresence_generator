require "anypresence_generator/repository/archive"
require "anypresence_generator/repository/git"

module AnypresenceGenerator
  module Repository

    attr_accessor :repository

    def init_or_clone
      if new_generation?
        log "Creating project directories and initializing source control"
        repository.init
      else
        log "Retrieving project from source control"
        repository.clone(true)
      end
    end

    def commit_to_repository(user_name: nil, user_email: nil, commit_message: nil)
      log "Committing to local source control"
      repository.commit(user_name, user_email, commit_message)
    end

    def push_to_repository
      log "Pushing to remote source control."
      repository.push
    end

    def setup_repository
      log 'Setting up repository.'
      if payload.repository.type.eql?("ApplicationDefinition::Repository::Archive".freeze)
        self.repository = ::AnypresenceGenerator::Repository::Archive.new(repository_payload: payload.repository, directory: project_directory)
      elsif payload.repository.type.eql?("ApplicationDefinition::Repository::Github".freeze)
        self.repository = ::AnypresenceGenerator::Repository::Git.new(repository_payload: payload.repository, directory: project_directory)
      else
        raise WorkableError.new("Unsupported repository type: #{payload.repository.type}")
      end
    end

    def new_generation?
      !repository.pushed
    end

  end
end