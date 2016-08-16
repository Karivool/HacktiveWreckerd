require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    Object.const_get(@class_name)
  end

  def table_name
    self.class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    options[:foreign_key] ||= "#{name.downcase}_id".to_sym
    options[:class_name] ||= "#{name.capitalize}"
    options[:primary_key] ||= :id

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, class_name, options = {})
    options[:foreign_key] ||= "#{class_name.to_s.downcase}_id".to_sym
    options[:class_name] ||= name.to_s.chop.capitalize
    options[:primary_key] ||= :id

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_match = self.send(options.foreign_key)

      options
      .model_class
      .where(options.primary_key => foreign_match)
      .first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self, options)

    define_method(name) do
      options = self.class.assoc_options[name]
      primary_match = self.send(options.primary_key)

      self.class.assoc_options[name]
      .model_class
      .where(self.class.assoc_options[name].foreign_key => primary_match)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable

end
