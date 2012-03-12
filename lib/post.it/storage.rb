module PostIt
  module Storage
    class << self
      def resolve(storage)
        case storage
        when "sqlite"
          Storage.const_get("SQLite").new

        # TODO
        #   json, mysql, (redis, mongo)
        end
      end
    end
  end
end

