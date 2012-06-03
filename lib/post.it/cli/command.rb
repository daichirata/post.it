module PostIt
  module CLI
    class Command
      class << self
        def delegate(command, message, tags, limit)
          return help                  if command == 'help'
          return delete(message)       if command == 'delete'
          return search(tags, limit)   if command == 'search' || !message
          return create(message, tags) if message

          raise ArgumentError
        end

        def create(message, tags)
          post = Model::Post.create(:body => message)
          if tags
            tags.each do |tag|
              t = Model::Tag.find_or_create(:name => tag)
              post.add_tag(t)
            end
          end

          CLI::Output.create(post)
        end

        def search(tags, limit)
          posts = Model::Post
          if tags
            tags = tags.map {|tag| Tag.find(:name => tag)}
            posts.filter(:tags => tags)
          end
          CLI::Output.search posts.limit(limit || 15).all
        end

        def delete(id)
        end

        def help
          CLI::Output.help
        end
      end
    end
  end
end
