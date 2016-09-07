require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

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
    found_query = DBConnection.execute("SELECT #{table_name}.* FROM #{table_name} WHERE id = #{id}")
    found_query.length >= 1 ? parse_all(found_query).first : nil
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
    this = self.class
    columns = this.columns.drop(1)
    column_names = columns.join(", ")
    question_marks = (["?"] * columns.length).join(", ")

    DBConnection.execute(<<-SQL, attribute_values)
      INSERT INTO #{this.table_name} (#{column_names})
      VALUES (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    user_id = self.attributes[:id]
    this = self.class
    columns = this.columns.drop(1)

    column_changes = columns.map do |attribute|
      "#{attribute} = ?"
    end.join(", ")

    DBConnection.execute(<<-SQL, attribute_values.drop(1))
      UPDATE #{this.table_name}
      SET #{column_changes}
      WHERE id = #{user_id}
    SQL
  end

  def save
    if self.id == nil || self.class.find(self.id) == nil
      self.insert
    else
      self.update
    end
  end
end
