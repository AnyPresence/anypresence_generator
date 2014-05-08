require 'anypresence_generator'

class MagicalDeployer < AnypresenceGenerator::Deployer
  steps :prepare, :setup, :deploy_away, :cleanup

  def prepare
    log 'Preparing deployment.'
  end

  def setup
    log 'I will setup...'
    run_command("ls")
    log 'I just did setup!'
  end

  def deploy_away
    log 'Deploy time!'
  end

  def cleanup
    log 'Cleaning up!'
  end
end