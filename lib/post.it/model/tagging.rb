module PostIt
  module Model
    class Tagging < Sequel::Model
      one_to_many :taggings
      many_to_many :posts, :join_table => :taggings
    end
  end
end
