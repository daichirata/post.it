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

      def self.find_by_tag(params)
        if params[:tags]
          values = Tag.parse(params[:tags]).map do |tag|
            if it = Tag.first(:name => tag)
              %[%"#{it['id']}"%]
            else
              return tag
            end
          end.compact

          find(:tag_ids => values, :limit => params[:limit])
        else
          find(:limit => params[:limit])
        end
      end

    end
  end

  Post = Model::Post
end
