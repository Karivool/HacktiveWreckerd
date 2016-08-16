require 'byebug'

require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    @columns = []
    columns = DBConnection.execute2("SELECT * FROM #{table_name}").first
    columns.each { |column| @columns << column.to_sym }

    @columns
  end

  def self.finalize!
    columns.each do |column|

      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |value|
        attributes[column] = value
      end

    end
    @attributes
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    @all = DBConnection.execute("SELECT #{table_name}.* FROM #{table_name}")
    parse_all(@all)
  end

  def self.parse_all(results)
    parsed_results = []

    results.each_with_index do |params|
      parsed_results.push(self.new(params))
    end

    parsed_results
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    columns = self.class.columns

    params.each do |key, value|
      unless columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      else
        self.send("#{key.to_sym}=", value)
      end
    end
  end

  def attributes
    @attributes = @attributes.nil? ? {} : @attributes
  end

  def attribute_values
    @attributes.values
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
