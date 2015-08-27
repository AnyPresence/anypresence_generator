require 'anypresence_generator/workhorse'
require 'anypresence_generator/payload/build'

module AnypresenceGenerator
  class Generator < AnypresenceGenerator::Workhorse
    include AnypresenceGenerator::Payload::Build

    def steps
      [:setup_repository, :init_or_clone] + self.class._steps + [:commit_to_repository, :push_to_repository, :upload_artifacts, :upload_readme]
    end
  end
end
