require 'oj'

module AnypresenceGenerator
  module Payload
    module Deployment
      TYPES = [:deployment]
      PAYLOAD_ATTRIBUTES = [:deployment, :build, :environment, :application_definition]
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
        return deployment
      end

    end
  end
end