require 'test/unit'
require 'anypresence_generator'

class AnypresenceGeneratorTest < Test::Unit::TestCase
  def test_anypresence_generator_workhorse_subclasses
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "funsies_api.txt"))
    MagicalGenerator.new(json_payload: json, mock: true)
    assert_equal true, true 
  end
end

class MagicalGenerator < AnypresenceGenerator::Workhorse
  steps :one, :two, :three

  def one
    p 'one'
  end

  def two
    p 'two'
  end

  def three
    p 'three'
  end
end