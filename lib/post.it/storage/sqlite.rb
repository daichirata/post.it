module PostIt
  module Storage
    class SQLite
      def initialize
        @connection = SQLite3::Database.new(PostIt.config['sqlite_file'])
        @connection.results_as_hash = true

        preparation
      end

      def create(params)
        sql = "INSERT INTO #{params.delete(:table_name)}\n"
        name, values = [], []
        params.each do |key, value|
          name   << key
          values << %Q('#{value}')
        end
        sql << " (#{name.join(', ')})\nVALUES\n (#{values.join(', ')})"
        execute(sql)
      end

      def find_all(params)
        sql = find(params)
        execute(sql, params)
      end

      def find_first(params)
        sql = find(params)
        execute_first(sql, params)
      end

      def find(params)
        sql = "SELECT * FROM #{params.delete(:table_name)}\nWHERE\n"
        sql << params.map do |key, value|
          " #{key} = :#{key}"
        end.join("\nAND\n")
      end

      def preparation
        PostIt.models.each do |model|
          table_name, column = PostIt.const_get(model).scheme
          create_table(table_name, column) unless table_exists?(table_name)
        end
      end

      def table_exists?(table_name)
        sql = <<-SQL.gsub(/^ {10}/, '')
          SELECT name
          FROM sqlite_master
          WHERE type = 'table'
            AND NOT name = 'sqlite_sequence'
            AND name = (:table_name)
        SQL
        execute(sql, table_name).any?
      end

      def create_table(table_name, column_info)
        sql  = "CREATE TABLE #{table_name} (\n"
        sql << "  id integer PRIMARY KEY AUTOINCREMENT,\n"
        sql << column_info.map do |name, type|
          "  #{name} #{type}"
        end.join(",\n") << "\n);"
        execute(sql)
      end

      def execute(sql, place_holder = nil)
        debug(sql) { @connection.execute(sql, place_holder) }
      end

      def execute_first(sql, place_holder = nil)
        debug(sql) { @connection.get_first_row(sql, place_holder) }
      end

      def debug(value)
        STDOUT.puts(value + "\n\n") if PostIt.debug
        yield
      end
    end
  end
end
