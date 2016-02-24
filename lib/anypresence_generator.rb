require 'recursive-open-struct'
require 'fast_blank'

require "anypresence_generator/version"
require "anypresence_generator/template"
require "anypresence_generator/workhorse"
require "anypresence_generator/generator"
require "anypresence_generator/deployer"
require "anypresence_generator/repository"
require "anypresence_generator/command"
require "anypresence_generator/log"
require 'anypresence_generator/repository'

module AnypresenceGenerator;end

class RecursiveOpenStruct
  attr_reader :_parent

  def initialize(hash=nil, args={})
    super(hash)
    @recurse_over_arrays = args.fetch(:recurse_over_arrays, false)
    @preserve_original_keys = args.fetch(:preserve_original_keys, false)
    @deep_dup = DeepDup.new(recurse_over_arrays: @recurse_over_arrays, preserve_original_keys: @preserve_original_keys)
    @sub_elements = {}
    @_parent = args[:_parent]
  end

  def new_ostruct_member(name)
    key_name = _get_key_from_table_ name
    unless self.methods.include?(name.to_sym)
      class << self; self; end.class_eval do
        define_method(name) do
          v = @table[key_name]
          if v.is_a?(Hash)
            @sub_elements[key_name] ||= self.class.new(
              v,
              _parent: self,
              recurse_over_arrays: @recurse_over_arrays,
              preserve_original_keys: @preserve_original_keys,
              mutate_input_hash: true
            )
          elsif v.is_a?(Array) and @recurse_over_arrays
            @sub_elements[key_name] ||= recurse_over_array(v)
            @sub_elements[key_name] = recurse_over_array(@sub_elements[key_name])
          else
            v
          end
        end
        define_method("#{name}=") do |x|
          @sub_elements.delete(key_name)
          modifiable[key_name] = x
        end
        define_method("#{name}_as_a_hash") { @table[key_name] }
      end
    end
    key_name
  end

  private

  def recurse_over_array(array)
    array.map do |a|
      if a.is_a? Hash
        self.class.new(a, :_parent => self, :recurse_over_arrays => true, :mutate_input_hash => true)
      elsif a.is_a? Array
        recurse_over_array a
      else
        a
      end
    end
  end
end
