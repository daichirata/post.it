module PostIt
  module Model
    class Tag < Base
      table_name :tags
      column :name => :string, :created_at => :datetime

      def self.first_or_create(params)
        p first(params)
        unless value = first(params)
          create(params)
          value = first(params)
        end
        value
      end

      def self.parse(tags)
        s = tags.split(':')
        s.size > 1 ? s[1..-1] : s
      end
    end
  end

  Tag = Model::Tag
end
