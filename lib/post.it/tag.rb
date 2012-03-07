module PostIt
  class Tag < Storage::Base
    table_name :tags
    column :name => :string, :created_at => :datetime

    def self.find_or_create(params)
      unless value = find(params)
        create(params)
        value = find(params)
      end
      value
    end

    def self.parse(tags)
      s = tags.split(':')
      s.size > 1 ? s[1..-1] : s
    end
  end
end
