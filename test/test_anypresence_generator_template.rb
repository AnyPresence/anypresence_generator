require 'test/unit'
require 'support/magical_generator'
require 'support/magical_template'

class AnypresenceGeneratorTemplateTest < Test::Unit::TestCase

  def test_anypresence_generator_template_subclasses
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    assert_nothing_raised do
      generator = MagicalGeneratorWithTemplate.new(json_payload: json, auth_token: 'test', mock: true)
      MagicalTemplate.new(generator: generator)
    end
  end

  def test_anypresence_generator_with_templates
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    Dir.mktmpdir do |dir|
      generator = MagicalGeneratorWithTemplate.new(json_payload: json, auth_token: 'test', mock: true, dump_project_directory: dir)
      assert generator.start!
      template_output = File.read(File.expand_path('magic.txt', dir))
      generator.object_definitions.each do |object_defintion|
        assert template_output.include?(object_defintion.name)
        object_defintion.field_definitions.each { |field_definition| assert template_output.include?(field_definition.name) }
      end
    end
  end

  def test_anypresence_generator_with_templates_and_output_file
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    Dir.mktmpdir do |dir|
      generator = MagicalGeneratorWithTemplateAndOutput.new(json_payload: json, auth_token: 'test', mock: true, dump_project_directory: dir)
      assert generator.start!
      template_output = File.read(File.join(dir, MagicalTemplateWithSpecificOutput.new(generator: generator).output_path, MagicalTemplateWithSpecificOutput.new(generator: generator).output_file))
      generator.object_definitions.each do |object_defintion|
        assert template_output.include?(object_defintion.name)
        object_defintion.field_definitions.each { |field_definition| assert template_output.include?(field_definition.name) }
      end
    end
  end

end