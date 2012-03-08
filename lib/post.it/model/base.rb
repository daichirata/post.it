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

        def delete(params)
          params = {
            :table_name => @table_name,
            :query => params
          }
          storage.delete(params)
        end

        def find(params)
          limit = params.delete(:limit) || PostIt.default_limit
          params = {
            :table_name => @table_name,
            :limit => limit,
            :query => params
          }
          storage.find(params)
        end

        def first(params)
          params = params.merge({
            :limit => 1
          })
          find(params)[0]
        end
      end
    end
  end
end
