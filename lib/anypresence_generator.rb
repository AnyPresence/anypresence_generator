require 'recursive-open-struct'
require 'fast_blank'

require "anypresence_generator/version"
require "anypresence_generator/template"
require "anypresence_generator/workhorse"
require "anypresence_generator/repository"
require "anypresence_generator/command"
require "anypresence_generator/log"
require 'anypresence_generator/repository'

module AnypresenceGenerator;end

class RecursiveOpenStruct
  attr_reader :_parent

  def initialize(h=nil, args={})
    @recurse_over_arrays = args.fetch(:recurse_over_arrays,false)
    super(h)
    @sub_elements = {}
    @_parent = args[:_parent]
  end

  def new_ostruct_member(name)
    name = name.to_sym
    unless self.respond_to?(name)
      class << self; self; end.class_eval do
        define_method(name) do
          v = @table[name]
          if v.is_a?(Hash)
            @sub_elements[name] ||= self.class.new(v, :_parent => self, :recurse_over_arrays => @recurse_over_arrays)
          elsif v.is_a?(Array) and @recurse_over_arrays
            @sub_elements[name] ||= recurse_over_array v
          else
            v
          end
        end
        define_method("#{name}=") { |x| modifiable[name] = x }
        define_method("#{name}_as_a_hash") { @table[name] }
      end
    end
    name
  end

  def recurse_over_array array
    array.map do |a|
      if a.is_a? Hash
        self.class.new(a, :_parent => self, :recurse_over_arrays => true)
      elsif a.is_a? Array
        recurse_over_array a
      else
        a
      end
    end
  end
end

require 'anypresence_generator/payload'
