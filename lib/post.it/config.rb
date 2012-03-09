module PostIt
  class Config
    attr_reader :attributes

    def initialize
      bootstrap unless File.exist?(conf_file)
      load_attributes
    end

    def [](key)
      @attributes[key.to_s]
    end

    def attributes=(attrs)
      @attributes = attrs
      save
    end

    def conf_file
      "#{ENV['HOME']}/.postit.conf"
    end

    def sqlite_file
      "#{ENV['HOME']}/.postit.db"
    end

    def bootstrap
      @attributes = {
        :storage       => 'sqlite',
        :sqlite_file   => sqlite_file,
        :default_limit => 15
      }
      save
    end

    def load_attributes
      @attributes = MultiJson.decode(File.new(conf_file, 'r').read)
    end

    def save
      json = MultiJson.encode(attributes)
      File.open(conf_file, 'w') {|f| f.write(json) }
    end
  end
end
