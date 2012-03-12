module PostIt
  module Model
    DB = Sequel.connect("sqlite://#{ENV['HOME']}/.postit.db")

    DB.create_table?(:posts) do
      primary_key :id
      text :body
      timestamp :created_at
    end

    DB.create_table?(:tags) do
      primary_key :id
      text :name
    end

    DB.create_table?(:taggings) do
      primary_key :id
      foreign_key :post_id, :table => :posts
      foreign_key :tag_id, :table => :tags
    end
  end
end
