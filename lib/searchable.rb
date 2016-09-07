require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    search_params = params.map do |attribute|
      "#{attribute[0]} = '#{attribute[1]}'"
    end.join(" AND ")

    found_query = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        #{search_params}
    SQL

    parse_all(found_query)
  end
end
