require 'anypresence_generator'

class MagicalTemplate < AnypresenceGenerator::Template
  file 'magic.txt'
  templates_path File.dirname(__FILE__)
  partials_path File.expand_path("partials", File.dirname(__FILE__))
end