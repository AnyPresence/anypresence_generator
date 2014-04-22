require "anypresence_generator/templates/partial"

module AnypresenceGenerator
  module Templates
    # Writes the generated file(s) to disk in the directory passed.
    def write!(dir)
      templates_to_render.each do |filename, template_file|
        File.open(File.join(dir, filename), 'w') do |file|
          logger.info "Rendering template: #{template_file}"
          file.write ERB.new(File.read(template_file),nil,'<>').result(binding)
        end
      end
    end

    # A hash of generated_filename => template_filename values for the templates that should be rendered.
    def templates_to_render
      if template_filenames.is_a?(Array)
        template_filenames.inject({}) do |hash, filename|
          hash[filename] = template_file(filename)
          hash
        end
      elsif template_filenames.is_a?(String)
        { template_filenames => template_file(template_filenames) }
      elsif template_filenames.is_a?(Hash)
        template_filenames.inject({}) do |hash, (filename, template_filename)|
          hash[filename] = template_file(template_filename)
          hash
        end
      else
        raise 'template_filenames must return a string filename, an array of string filenames, or a hash of filename => template_file values'
      end
    end

    # One or more template files to render.
    #
    # May be a string filename, an array of string filenames, or a hash of filename => template_file values.
    def template_filenames
      raise 'Must be implemented by subclasses'
    end
  end
end