module PostIt
  module Model
    class Post < Sequel::Model
      one_to_many :taggings
      many_to_many :tags, :join_table => :taggings

      def before_create
        self.created_at = Time.now
      end
    end
  end
end
