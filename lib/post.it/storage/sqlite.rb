module PostIt
  module Storage
    class SQLite
      def initialize
        @connection = SQLite3::Database.new(PostIt.config['sqlite_file'])
        @connection.results_as_hash = true
        preparation
      end

      def create(params)
        table = Table[params[:table_name]]
        execute(table.insert(params[:query]).to_sql)
      end

      def delete()
      end

      def find(params)
        table = Table[params[:table_name]].limit(params[:limit])
        params[:query].each do |k, vals|
          case vals
          when String
            table.where(table[k].eq(vals))
          when Array
            vals.each do |v|
              table.where(table[k].like(v))
            end
          end
        end
        execute(table.to_sql)
      end

      def execute(sql)
        debug(sql) { @connection.execute(sql) }
      end

      def debug(value)
        if PostIt.debug
          STDOUT.puts(value + "\n\n")
        end
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
