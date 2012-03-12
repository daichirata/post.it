module PostIt
  module CLI
    class Command
      class << self
        include PostIt::CLI::Color
        include PostIt::CLI::Format

        def delegate(command, message, tags, limit)
          return help                  if command == 'help'
          return delete(message)       if command == 'delete'
          return search(tags, limit)   if command == 'search' || !message
          return create(message, tags) if message

          raise ArgumentError
        end

        def create(message, tags)
          post = Model::Post.create(:body => message)
          tags.each do |tag|
            t = Model::Tag.find_or_create(:name => tag)
            post.add_tag(t)
          end

          p post
          p post.tags
        end

        def search(tags, limit)
        end

        def delete(id)
          Model::Post[id].delete
        end

        def help
          output_help
        end
      end
    end
  end
end
