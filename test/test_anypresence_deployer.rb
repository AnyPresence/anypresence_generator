require 'test/unit'
require 'support/magical_deployer'

class AnypresenceDeployerTest < Test::Unit::TestCase
  def test_anypresence_deployer_workhorse_subclasses
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/heroku.txt"))
    assert_nothing_raised do
      MagicalDeployer.new(json_payload: json, auth_token: 'test', mock: true)
    end
  end

  def test_anypresence_deployer_workhorse_parses_heroku_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/heroku.txt"))
    deployer = MagicalDeployer.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil deployer.deployment
    assert_not_nil deployer.build
    assert_not_nil deployer.payload.repository
    assert_not_nil deployer.environment
    assert_equal   deployer.type, :deployment
    assert_equal   deployer.deployment.deployer, 'Heroku'
    assert_equal   deployer.new_deployment?, true
  end

  def test_anypresence_deployer_workhorse_parses_s3_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/s3.txt"))
    deployer = MagicalDeployer.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil deployer.deployment
    assert_not_nil deployer.build
    assert_not_nil deployer.payload.repository
    assert_not_nil deployer.environment
  end

  def test_anypresence_deployer_workhorse_executes_steps_during_processing
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/heroku.txt"))
    deployer = MagicalDeployer.new(json_payload: json, auth_token: 'test', mock: true)
    assert deployer.start!
    assert deployer.log_content.include?('Preparing deployment.')
    assert deployer.log_content.include?('I will setup...')
    assert deployer.log_content.include?('I just did setup!')
    assert deployer.log_content.include?('Deploy time!')
    assert deployer.log_content.include?('Cleaning up!')
  end

  def test_anypresence_generator_workhorse_setups_repository_during_processing
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/heroku.txt"))
    deployer = MagicalDeployer.new(json_payload: json, auth_token: 'test', mock: true)
    assert deployer.start!
    assert_not_nil deployer.repository
  end

end