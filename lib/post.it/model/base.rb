module PostIt
  module Model
    class Base
      class << self

        def storage
          PostIt.storage
        end

        def table_name(name)
          @table_name = name.to_s
          Model.list ||= []
          Model.list << self.name.sub('PostIt::Model::', '')
        end

        def column(column = {})
          @column = column
        end

        def scheme
          [@table_name, @column]
        end

        def create(params)
          params = {
            :table_name => @table_name,
            :query => params.merge({:created_at => Time.now})
          }
          storage.create(params)
        end

        def like(params)
          params = {
            :table_name => @table_name,
            :query => params
          }
          storage.like(params)
        end

        def first(params)
          params = {
            :table_name => @table_name,
            :query => params
          }
          storage.first(params)
        end

        def all(params)
          params = {
            :table_name => @table_name,
            :query => params
          }
          storage.all(params)
        end

      end
    end
  end
end
