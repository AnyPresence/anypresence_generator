require 'test/unit'
require 'support/magical_generator'

class AnypresenceGeneratorCommandTest < Test::Unit::TestCase

  def setup
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    @generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
  end

  def test_anypresence_command
    puts "\nExisting status code is #{$?.exitstatus}"
    assert_nothing_raised do
      @generator.run_command('date')
      @generator.run_command('date', abort: false)
      @generator.run_command('date')
    end
    puts "\nAFTER running status code is #{$?.exitstatus}"
  end

  def test_anypresence_command_silence
    puts "\nExisting status code is #{$?.exitstatus}"
    assert @generator.log_content.strip.empty?
    @generator.run_command('date', silence: true)      
    assert @generator.log_content.strip.empty?
    puts "\nAFTER running status code is #{$?.exitstatus}"
  end

  def test_anypresence_command_should_abort
    puts "\nExisting status code is #{$?.exitstatus}"
    assert_raise ::AnypresenceGenerator::Workhorse::WorkableError do
      @generator.run_command('magical_command_that_does_not_exist')
    end
    puts "\nAFTER running status code is #{$?.exitstatus}"
  end
end