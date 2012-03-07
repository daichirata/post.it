module PostIt
  class Post < PostIt::Storage::Base
    table_name :posts
    column :message => :string, :tag_ids => :string, :created_at => :datetime

    def self.create(params)
      tags = params.delete(:tags)
      params[:tag_ids] ||= []

      if tags
        Tag.parse(tags).each do |tag|
          params[:tag_ids] << "#{Tag.find_or_create(:name => tag)['id']}"
        end
        params[:tag_ids].sort!.uniq!
      end

      super(params)
    end

    def self.find_by_tag(tags, length)
      where = Tag.parse(tags).map do |tag|
        if it = Tag.find(:name => tag)
          %{tag_ids LILE '%"#{it['id']}"%'}
        end
      end.compact
    end
  end
end
