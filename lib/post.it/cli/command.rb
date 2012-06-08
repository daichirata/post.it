module PostIt
  module CLI
    class Command
      class << self
        def delegate(command, message, tags, limit)
          return help                  if command == 'help'
          return run(message)          if command == 'run'
          return delete(message, tags) if command == 'delete'
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
          posts = Model::Post.order(:created_at.desc)
          if tags
            tags = tags.each_with_object([]) do |tag_name, tag|
              _tag = Model::Tag.find(:name => tag_name)
              unless _tag
                CLI::Output.tag_not_found(tag_name)
                exit 0
              end
              tag << _tag
            end
            posts.filter!(:tags => tags)
          end
          CLI::Output.search posts.limit(limit || 10).all.reverse
        end

        def delete(id, tags)
          post = Model::Post.filter(:id => id).first
          if post && CLI::Output.confirm_delete?(post)
            post.remove_all_tags
            post.destroy
            CLI::Output.delete post
          else
            CLI::Output.post_not_found(id)
          end
        end

        def run(message)
          # TODO
          # background or deamon
          command = "ruby #{PostIt.root}/post.it/app.rb"
          system command
        end

        def help
          CLI::Output.help
        end
      end
    end
  end
end
