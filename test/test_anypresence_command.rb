require 'test/unit'
require 'support/magical_generator'

class AnypresenceGeneratorCommandTest < Test::Unit::TestCase

  def setup
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    @generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', git_user: 'Git User', git_email: 'git@example.com', mock: true)
  end

  def test_anypresence_command
    assert_nothing_raised do
      @generator.run_command('date')
      @generator.run_command('date', abort: false)
      @generator.run_command('date')
    end
  end

  def test_anypresence_command_silence
    assert @generator.log_content.strip.empty?
    @generator.run_command('date', silence: true)
    assert @generator.log_content.strip.empty?
  end

  def test_anypresence_command_should_abort
    assert_raise ::AnypresenceGenerator::Workhorse::WorkableError do
      @generator.run_command('magical_command_that_does_not_exist')
    end
  end
end