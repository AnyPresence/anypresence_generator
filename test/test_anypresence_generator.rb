require 'test/unit'
require 'support/magical_generator'

class AnypresenceGeneratorTest < Test::Unit::TestCase
  def test_anypresence_generator_workhorse_subclasses
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    assert_nothing_raised do
      MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    end
  end

  def test_anypresence_generator_workhorse_retains_raw_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_equal generator.raw_payload, json
  end

  def test_anypresence_generator_workhorse_parses_api_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.environment
    assert_not_nil generator.build
    assert_not_nil generator.api_version
    assert_not_nil generator.application_definition
  end

  def test_anypresence_generator_workhorse_parses_sdk_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/sdk.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.environment
    assert_not_nil generator.build
    assert_not_nil generator.api_version
    assert_not_nil generator.application_definition
  end

  def test_anypresence_generator_workhorse_parses_app_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.environment
    assert_not_nil generator.build
    assert_not_nil generator.api_version
    assert_not_nil generator.application_definition
  end

  def test_anypresence_generator_workhorse_executes_steps_during_processing
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert generator.start!
    assert generator.log_content.include?('I just did one!')
    assert generator.log_content.include?('I just did two!')
    assert generator.log_content.include?("Success?: true - Gemfile\nGemfile.lock")
    assert generator.log_content.include?('I just did three!')
  end

  def test_anypresence_generator_workhorse_setups_repository_during_processing
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert generator.start!
    assert_not_nil generator.repository
  end

  def test_anypresence_generator_workhorse_parses_full_depth_from_api_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.storage_interfaces
    assert_not_nil generator.object_definitions
    assert_not_nil generator.field_definitions(object_definition: generator.object_definitions.first)
  end

  def test_anypresence_generator_workhorse_parses_full_depth_from_sdk_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/sdk.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.object_definitions
    assert_not_nil generator.field_definitions(object_definition: generator.object_definitions.first)
  end

  def test_anypresence_generator_workhorse_parses_full_depth_from_app_payload
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/app.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.object_definitions
    assert_not_nil generator.field_definitions(object_definition: generator.object_definitions.first)
    assert_not_nil generator.root_page_component
  end

  def test_anypresence_generator_workhorse_api_payload_handles_selectors
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/api.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.storage_interface_by_name('Postgres')
    assert_not_nil generator.object_definition_by_name('Dog')
    assert_not_nil generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog'))
    assert_equal generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog')).name, 'name'
    assert_equal generator.key_field_definition(object_definition: generator.object_definition_by_name('Dog')).name, 'id'
    assert_not_nil generator.authenticatable_object_definition
    assert_equal generator.authenticatable_object_definition.name, 'User'
    assert generator.uses_authentication?
  end

  def test_anypresence_generator_workhorse_sdk_payload_handles_selectors
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/sdk.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.object_definition_by_name('Dog')
    assert_not_nil generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog'))
    assert_equal generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog')).name, 'name'
    assert_equal generator.key_field_definition(object_definition: generator.object_definition_by_name('Dog')).name, 'id'
    assert_not_nil generator.authenticatable_object_definition
    assert_equal generator.authenticatable_object_definition.name, 'User'
    assert generator.uses_authentication?
  end

  def test_anypresence_generator_workhorse_app_payload_handles_selectors
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/app.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.object_definition_by_name('Dog')
    assert_not_nil generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog'))
    assert_equal generator.field_definition_by_name('name', object_definition: generator.object_definition_by_name('Dog')).name, 'name'
    assert_equal generator.key_field_definition(object_definition: generator.object_definition_by_name('Dog')).name, 'id'
    assert_not_nil generator.authenticatable_object_definition
    assert_equal generator.authenticatable_object_definition.name, 'User'
    assert generator.uses_authentication?
    assert_not_nil generator.child_page_components(generator.root_page_component)
  end

  def test_anypresence_generator_workhorse_app_payload_handles_page_component_selectors
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/app.txt"))
    generator = MagicalGenerator.new(json_payload: json, auth_token: 'test', mock: true)
    assert_not_nil generator.child_page_components(generator.root_page_component)
    assert_not_nil generator.page_component_by_name('ContactListPage')
    assert_equal generator.page_component_by_name('ContactListPage').name, 'ContactListPage'
    assert_not_nil generator.configuration_page_components(generator.page_component_by_name('ContactListPage'))
    assert_equal generator.page_component_parent(generator.page_component_by_name('FunsiesContentPage')), generator.page_component_by_name('MainNavigation')
    assert_nil generator.page_component_by_name('DoesNotExist')
  end

  def test_anypresence_generator_workhorse_error_handler
    json = File.read(File.join(File.expand_path(File.dirname(__FILE__)), "support/app.txt"))
    generator = MagicalGeneratorWithErrorHandler.new(json_payload: json, auth_token: 'test', mock: true)
    assert !generator.start!
    assert generator.log_content.include?('Error handled!: Exception handler testing time.')
  end

end