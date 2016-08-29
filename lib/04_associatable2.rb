require_relative '03_associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_opts = self.class.assoc_options[through_name]
      source_opts = through_opts.model_class.assoc_options[source_name]

      through_table = through_opts.table_name
      through_pkey = through_opts.primary_key
      through_fkey = through_opts.foreign_key

      source_table = source_opts.table_name
      source_pkey = source_opts.primary_key
      source_fkey = source_opts.foreign_key

      key_val = self.send(through_fkey)

      query = DBConnection.execute(<<-SQL, key_val)
        SELECT #{source_table}.*
        FROM #{through_table}
        JOIN #{source_table}
        ON #{through_table}.#{source_fkey} = #{source_table}.#{source_pkey}
        WHERE #{through_table}.#{through_pkey} = ?
      SQL

      source_opts.model_class.parse_all(query).first

    end
  end
end
