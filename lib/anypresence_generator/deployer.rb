require 'anypresence_generator/workhorse'
require 'anypresence_generator/payload/deployment'

module AnypresenceGenerator
  class Deployer < AnypresenceGenerator::Workhorse
    include AnypresenceGenerator::Payload::Deployment

    def steps
      [:setup_repository, :init_or_clone] + self.class._steps
    end

    def new_deployment?
      !deployment.deployed
    end
  end
end