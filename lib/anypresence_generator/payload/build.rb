require 'oj'

module AnypresenceGenerator
  module Payload
    module Build
      TYPES = [:api, :sdk, :app]
      PAYLOAD_ATTRIBUTES = [:environment, :build, :api_version, :application_definition]
      attr_accessor :type, :payload
      attr_accessor *PAYLOAD_ATTRIBUTES

      def digest(json_payload: ( raise WorkableError.new('No JSON payload provided.'.freeze) ) )
        parsed_payload = RecursiveOpenStruct.new(Oj.load(json_payload), recurse_over_arrays: true)
        TYPES.each do |type|
          if parsed_payload.send(type)
            self.payload = parsed_payload.send(type)
            self.type = type
            break
          end
        end
        PAYLOAD_ATTRIBUTES.each do |attribute|
          self.send( "#{attribute}=", payload.send(attribute) )
        end
        return build
      end

      def storage_interfaces
        @storage_interfaces ||= application_definition.storage_interfaces
      end

      def storage_interface_by_name(name)
        storage_interfaces.select { |storage_interface| storage_interface.name.eql?(name) }.first
      end

      def object_definitions
        @object_definitions ||= application_definition.object_definitions
      end

      def object_definition_by_name(name)
        object_definitions.select { |object_definition| object_definition.name.eql?(name) }.first
      end

      def authenticatable_object_definition
        @authenticatable_object_definition ||= object_definitions.select { |object_definition| object_definition.type.eql?("AuthenticatableObjectDefinition".freeze) }.first
      end

      def uses_authentication?
        !!authenticatable_object_definition
      end

      def field_definitions(object_definition: ( raise PayloadError.new("Object definition required.".freeze) ) )
        object_definition.field_definitions
      end

      def field_definition_by_name(name, object_definition: ( raise PayloadError.new("Object definition required.".freeze) ) )
        object_definition.field_definitions.select { |field_definition| field_definition.name.eql?(name) }.first
      end

      def key_field_definition(object_definition: ( raise PayloadError.new("Object definition required.".freeze) ) )
        object_definition.field_definitions.select { |field_definition| field_definition.key }.first
      end

      def root_page_component
        @root_page_component ||= application_definition.root_page_component
      end

      def page_component_parent(page_component)
        page_component._parent
      end

      def child_page_components(page_component)
        page_component.children
      end

      def page_component_by_name(name)
        return root_page_component if root_page_component.name.eql?(name)
        full_traverse_of_page_component(root_page_component) { |component| return component if component.name.eql?(name) }.compact.select { |result| result.name.eql?(name) }.first
      end

      def full_traverse_of_page_component(page_component)
        traverse_page_component(page_component) do |component|
          yield component
          configuration_page_components(component).each do |configuration_component| 
            full_traverse_of_page_component(configuration_component) { |c| yield(c) }
          end
        end
      end

      def traverse_page_component(page_component, &block)
        block ||= lambda { |node| node }
        result = [block.call(page_component)] + child_page_components(page_component).collect { |c| traverse_page_component(c, &block) }
        result.flatten
      end

      def configuration_page_components(page_component)
        [:page, :list_item, :title_bar_button, :success_page].map{ |configuration_component| page_component.send(configuration_component) }.select{ |component| !component.nil? }
      end

    end
  end
end