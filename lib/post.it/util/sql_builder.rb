module PostIt
  module Util
    module SqlBuilder
      def self.[](table_name)
        SqlBuilder::Table.new(table_name)
      end

      class Table
        def initialize(table_name)
          @table_name = table_name
          @select = nil
          @limit = nil
        end

        def [](name)
          Query.new(@table_name, name)
        end

        def limit(num)
          @limit ||= "LIMIT #{num}"
          self
        end

        def insert(params = nil)
          Insert.new(@table_name, params)
        end

        def create(column_info)
          Create.new(@table_name, column_info)
        end

        def select(target = '*')
          @select ||= Select.new(@table_name, target)

          if block_given?
            yield @select
          end
        end

        def where(query)
          @select ||= Select.new(@table_name, '*')
          @select.where(query)
        end

        def to_sql
          @select ||= Select.new(@table_name, '*')
          [@select.to_sql, @limit].join(' ')
        end
      end

      class Query
        def initialize(table_name, column_name)
          @subject = column(table_name, column_name)
        end

        def column(table_name, column_name)
          "#{table_name}.#{column_name}"
        end

        def eq(value)
          "#{@subject} = '#{value}'"
        end

        def not_eq(value)
          "NOT #{@subject} = '#{value}'"
        end

        def like(value)
          "#{@subject} LIKE '#{value}'"
        end
      end

      class Select
        def initialize(table_name, target)
          @query = "SELECT #{target} FROM #{table_name}"
          @where = []
        end

        def where(query)
          @where << query
          self
        end

        def to_sql
          if @where.empty?
            @query
          else
           [@query, @where.join(' AND ')].join(' WHERE ')
          end
        end
      end

      class Create
        def initialize(table_name, column_info)
          @query  = "CREATE TABLE #{table_name}"
          @column = []

          column_build('id', 'integer PRIMARY KEY AUTOINCREMENT')
          column_info.each do |name, type|
            column_build(name, type)
          end
        end

        def column_build(name, type)
          @column << "#{name} #{type}"
        end

        def to_sql
          [@query, "(#{@column.join(', ')});"].join(' ')
        end
      end

      class Insert
        def initialize(table_name, params)
          @query  = "INSERT INTO #{table_name}"
          @keys   = []
          @values = []

          case params
          when Hash
            params.each do |k, v|
              @keys   << k.to_s
              @values << "'#{v}'"
            end
          when Array
            @keys = params.map(&:to_s)
          end
        end

        def values(params)
          params.each do |v|
            @values << "'#{v}'"
          end
          self
        end

        def build
          ["(#{@keys.join(', ')})", "(#{@values.join(', ')})"].join(' VALUES ')
        end

        def to_sql
          [@query, build].join(' ')
        end
      end
    end
  end

  module Storage
    Table = PostIt::Util::SqlBuilder
  end
end

