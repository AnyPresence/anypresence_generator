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
      raise TemplateError.new('templates_path must be set'.freeze) unless respond_to?(:templates_path)
      raise TemplateError.new('partials_path must be set'.freeze) unless respond_to?(:partials_path)
    end

    # Writes the generated file(s) to disk in the directory passed.
    def write!
      path = File.join(project_directory, filename).split('/').reverse.drop(1).reverse.join('/')
      FileUtils.mkdir_p(path) unless File.exists?(path)

      File.open(File.join(project_directory, filename), 'w'.freeze) do |file|
        proc = ::Proc.new {}
        file.write ERB.new(File.read(template_file),nil,'<>'.freeze).result(proc.binding)
      end
    end

    # Returns the absolute path of this instance's source template file
    def template_file
      File.expand_path("#{filename.split('/').last}.erb", templates_path)
    end

    # Returns the absolute path of the source partial template with the given +partial_name+   
    def partial_file(name: ( raise TemplateError.new('Partial name is required.'.freeze) ))
      File.expand_path("_#{name}.erb", partials_path)
    end

    def self.file(filename)
      define_method(:filename) { filename }
    end

    def self.templates_path(template_path)
      define_method(:templates_path) { template_path }
    end

    def self.partials_path(partial_path)
      define_method(:partials_path) { partial_path }
    end
  end
end