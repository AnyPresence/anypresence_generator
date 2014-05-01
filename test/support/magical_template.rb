require 'anypresence_generator'

class MagicalTemplate < AnypresenceGenerator::Template
  template_file 'magic.txt'
  templates_path File.dirname(__FILE__)
  partials_path File.expand_path("partials", File.dirname(__FILE__))
end

class MagicalTemplateWithSpecificOutput < AnypresenceGenerator::Template
  template_file 'magic.txt'
  output_file 'unicorn.rb'
  output_path '/magical/path'
  templates_path File.dirname(__FILE__)
  partials_path File.expand_path("partials", File.dirname(__FILE__))
end