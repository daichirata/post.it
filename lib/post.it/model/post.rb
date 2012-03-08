module PostIt
  module Model
    class Post < Base
      table_name :posts
      column :message => :string, :tag_ids => :string, :created_at => :datetime

      def self.create(params)
        tags = params.delete(:tags)
        params[:tag_ids] ||= []

        if tags
          Tag.parse(tags).each do |tag|
            params[:tag_ids] << "#{Tag.first_or_create(:name => tag)['id']}"
          end
          params[:tag_ids].sort!.uniq!
        end

        super(params)
      end

      def self.find_by_tag(tags, length)
        values = Tag.parse(tags).map do |tag|
          if it = Tag.first(:name => tag)
            %.%"#{it['id']}"%.
          end
        end.compact

        unless values.empty?
          like({:tag_ids => values})
        end
      end
    end
  end

  Post = Model::Post
end
