module PostIt
  module Storage
    class Base
      class << self

        def storage
          PostIt.storage
        end

        def table_name(name)
          @table_name = name.to_s
          PostIt.models ||= []
          PostIt.models << self.name.sub('PostIt::', '')
        end

        def column(column = {})
          @column = column
        end

        def scheme
          [@table_name, @column]
        end

        def create(params)
          params = params.merge({
            :table_name => @table_name,
            :created_at => Time.now
          })
          storage.create(params)
        end

        def find(params)
          params = params.merge({
            :table_name => @table_name,
          })
          storage.find_first(params)
        end

        def find_all(params)
          params = params.merge({
            :table_name => @table_name,
          })
          storage.find_all(params)
        end
      end
    end
  end
end
