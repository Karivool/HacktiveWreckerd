require 'byebug'

require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    @columns = []
    columns = DBConnection.execute2("SELECT * from #{table_name}").first
    columns.each { |column| @columns << column.to_sym }

    @columns
  end

  def self.finalize!
    
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # debugger
    @table_name ||= "#{self}".tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    @attributes = @attributes.nil? ? {} : @attributes
  end

  def attribute_values
    # ...
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
