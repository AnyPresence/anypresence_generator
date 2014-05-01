require "erb"
require "anypresence_generator/workhorse"
require "anypresence_generator/template/partial"

module AnypresenceGenerator
  class Template
    class TemplateError < StandardError; end
    include Partial

    attr_accessor :generator, :project_directory

    def initialize(generator: ( raise TemplateError.new('Generator workhorse is required.'.freeze) ) )
      self.generator = generator
      self.project_directory = generator.project_directory
      raise TemplateError.new('template_file must be set'.freeze) unless respond_to?(:template_file)
      raise TemplateError.new('templates_path must be set'.freeze) unless respond_to?(:templates_path)
      raise TemplateError.new('partials_path must be set'.freeze) unless respond_to?(:partials_path)
    end

    # Writes the generated file(s) to disk in the directory passed.
    def write!
      path = File.join(project_directory, output_path)
      FileUtils.mkdir_p(path) unless File.exists?(path)

      File.open(File.join(path, output_file), 'w'.freeze) do |file|
        proc = ::Proc.new {}
        file.write ERB.new(File.read(File.join(templates_path, "#{template_file}.erb")), nil, '<>'.freeze).result(proc.binding)
      end
    end

    # Returns the absolute path of the source partial template with the given +partial_name+
    def partial_file(name: ( raise TemplateError.new('Partial name is required.'.freeze) ))
      File.expand_path("_#{name}.erb", partials_path)
    end

    def self.template_file(filename)
      define_method(:template_file) { filename }
    end

    def self.output_file(filename)
      define_method(:output_file) { filename }
    end

    def output_file
      template_file
    end

    def fully_qualified_output_file
      File.join(project_directory, output_path, output_file)
    end

    def self.output_path(path)
      define_method(:output_path) { path }
    end

    def output_path
      '/'.freeze
    end

    def self.templates_path(template_path)
      define_method(:templates_path) { template_path }
    end

    def self.partials_path(partial_path)
      define_method(:partials_path) { partial_path }
    end
  end
end