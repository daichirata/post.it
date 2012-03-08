module PostIt
  module Storage
    class SQLite
      def initialize
        @connection = SQLite3::Database.new(PostIt.config['sqlite_file'])
        @connection.results_as_hash = true
        preparation
      end

      def like(params)
        table = Table[params[:table_name]]
        params[:query].each do |k, vals|
          vals.each do |v|
            table.where table[k].like(v)
          end
        end
        execute(table.to_sql)
      end

      def all(params)
        table = Table[params[:table_name]]
        params[:query].each do |k, v|
          table.where(table[k].eq(v))
        end
        execute(table.to_sql)
      end

      def first(params)
        table = Table[params[:table_name]]
        params[:query].each do |k, v|
          table.where(table[k].eq(v))
        end
        execute_first(table.to_sql)
      end

      def create(params)
        table = Table[params[:table_name]]
        execute(table.insert(params[:query]).to_sql)
      end

      def execute(sql, place_holder = nil)
        debug(sql){@connection.execute(sql, place_holder)}
      end

      def execute_first(sql, place_holder = nil)
        debug(sql){@connection.get_first_row(sql, place_holder)}
      end

      def debug(value)
        STDOUT.puts(value + "\n\n") if PostIt.debug
        yield
      end

      def preparation
        PostIt::Model.list.each do |model|
          table_name, column = PostIt::Model.const_get(model).scheme
          create_table(table_name, column) unless table_exists?(table_name)
        end
      end

      def table_exists?(table_name)
        table = Table[:sqlite_master]
        table.select('name') do |t|
          t.where table[:type].eq('table')
          t.where table[:name].not_eq('sqlite_sequence')
          t.where table[:name].eq(table_name)
        end
        execute(table.to_sql).any?
      end

      def create_table(table_name, column_info)
        execute(Table[table_name].create(column_info).to_sql)
      end
    end
  end
end
