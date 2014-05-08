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

class MagicalGeneratorWithTemplate < MagicalGenerator
  steps :one, :two, :three

  def three
    log 'I will generate a template...'
    run_templates MagicalTemplate.new(generator: self)
    log 'I generated a template!'
  end
end

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