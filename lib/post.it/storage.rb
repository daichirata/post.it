module PostIt
  module Storage
    class << self
      def resolve(storage)
        case storage
        when "sqlite"
          Storage.const_get("SQLite").new

        # TODO
        #   TextFile(json), MySQL, MongoDB
        when "json"
        when "mysql"
        when "mongo"
        end
      end
    end
  end
end

