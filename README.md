# AnypresenceGenerator

    This gems handles the basic interactions between generation and deployment processes and the AP platform API.

## Installation

Add this line to your application's Gemfile:

    gem 'anypresence_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anypresence_generator

## Usage

A basic generator class:

    require 'anypresence_generator'
    require 'support/magical_template'
    
    class MagicalGenerator < AnypresenceGenerator::Generator
      steps :one, :two, :three
    
      def one
        log 'I just did one!'
      end
    
      def two
        log 'I will do two...'
        run_command("ls")
        log 'I just did two!'
      end
    
      def three
        log 'I just did three!'
      end
    end

A generator that evaluates templates:

    class MagicalGeneratorWithTemplate < MagicalGenerator
      steps :one, :two, :three
      
      def three
        log 'I will generate a template...'
        run_templates MagicalTemplate.new(generator: self)
        log 'I generated a template!'
      end
    end

A generator that evaluates templates and do something special with the result:

    class MagicalGeneratorWithTemplateAndOutput < MagicalGenerator
      steps :one, :two, :three
    
      def three
        log 'I will generate a template...'
        run_templates MagicalTemplateWithSpecificOutput.new(generator: self) do |file_location|
          log "Writing to specific output file at #{file_location}"
        end
        log 'I generated a template!'
      end
    end

Example template that uses the AP platform payload helpers (magic.txt.erb):

    <% generator.object_definitions.each do |object_definition| %>
      Object Definition: <%= object_definition.name %>
        Fields:
          <%= render_partial name: 'magical_partial', locals: { fields: object_definition.field_definitions } %>
    <% end %>

Associated partial:

    <% fields.each do |field_definition| %>
      <%= field_definition.name %>
    <% end %>


Deployers work the same way as the generators:

    require 'anypresence_generator'
    
    class MagicalDeployer < AnypresenceGenerator::Deployer
      steps :prepare, :setup, :deploy_away, :cleanup
    
      def prepare
        log 'Preparing deployment.'
      end
    
      def setup
        log 'I will setup...'
        run_command("ls")
        log 'I just did setup!'
      end
    
      def deploy_away
        log 'Deploy time!'
      end
    
      def cleanup
        log 'Cleaning up!'
      end
    end

## Contributing

1. Fork it ( http://github.com/<my-github-username>/anypresence_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
