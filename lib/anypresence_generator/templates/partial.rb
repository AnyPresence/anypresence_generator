module AnypresenceGenerator
  module Templates
    class PartialGenerator
      # This object responds to local variables for partial rendering.
      def respond_to?(method, include_private = false)
        (@locals && @locals.last.is_a?(Hash) && @locals.last.has_key?(method)) || super
      end

    protected

      # Renders partial templates.
      def render_partial(name, options={})
        @locals ||= []
        @locals.push options[:locals]
        indent = options[:indent] || 0
        logger.info "Rendering partial: #{partial_file(name)}"
        output = ERB.new(File.read(partial_file(name)),nil,'<>').result(binding)
        if indent > 0
          output = output.gsub(/^/, ' ' * indent)
        end
        @locals.pop
        output
      end

      # The file that contains the partial referenced by the name.
      def partial_file(partial_name)
        raise 'must be implemented by subclasses'
      end

      # The method missing implementation allows access to "local variables" in partials.
      def method_missing(method, *args, &block)
        if respond_to?(method)
          @locals.last[method]
        else
          super
        end
      end
    end
  end
end