require "erb"
require "anypresence_generator/template"

module AnypresenceGenerator
  class Template
    module Partial

      attr_accessor :locals

      # This object responds to local variables for partial rendering.
      def respond_to?(method, include_private = false)
        (locals && locals.last.is_a?(Hash) && locals.last.has_key?(method)) || super
      end

    protected

      # Renders partial templates.
      def render_partial(name: ( raise AnypresenceGenerator::Template::TemplateError.new('Partial name is required.'.freeze) ), locals: nil, indent: 0)
        self.locals ||= []
        self.locals.push locals
        proc = ::Proc.new {}
        output = ERB.new(File.read(partial_file(name: name)),nil,'<>'.freeze).result(proc.binding)
        if indent > 0
          output = output.gsub(/^/, ' ' * indent)
        end
        self.locals.pop
        output
      end

      # The file that contains the partial referenced by the name.
      def partial_file(name: ( raise AnypresenceGenerator::Template::TemplateError.new('Partial name is required.'.freeze) ) )
        raise 'must be implemented by implementation class'
      end

      # The method missing implementation allows access to "local variables" in partials.
      def method_missing(method, *args, &block)
        if respond_to?(method)
          locals.last[method]
        else
          super
        end
      end
    end
  end
end