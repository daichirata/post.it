module PostIt
  module CLI
    class Command
      extend PostIt::CLI::Format

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

          output_create(post)
        end

        def search(tags, limit)
          tags = tags.map {|tag| Tag.find(:name => tag)}
          posts = Model::Post.filter(:tags => tags).limit(limit || 15).all

          output_search(posts)
        end

        def delete(id)
        end

        def help
          format_help
        end
      end
    end
  end
end
