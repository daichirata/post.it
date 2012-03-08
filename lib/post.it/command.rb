module PostIt
  class Command
    class << self
      include PostIt::Util::Color
      include PostIt::Util::CLIFormat

      def run(*args)
        command = message = tag = limit = nil

        args.each do |arg|
          case arg
          when 'search', 'help'
            command ||= arg
          when /^:.+/o
            tag ||= arg
          when /^-[0-9]+$/o
            limit ||= arg.to_i.abs
          else
            message ||= arg
          end
        end

        delegate(command, message, tag, limit)
      end

      def delegate(command, message, tag, limit)
        return help                 if command == 'help'
        return search(tag, limit)  if command == 'search' || !message
        return create(message, tag) if message

        raise ArgumentError
      end

      def create(message, tags)
        Post.create({
          :message => message,
          :tags => tags
        })

        puts_create(message, tags)
      end

      def search(tags, limit)
        result = Post.find_by_tag(:tags => tags, :limit => limit)

        case result
        when Array
          puts_search(result, tags)
        when String
          puts_tag_not_found(result)
        end
        #output tag, limit
      end

      def help
        output <<-EOH.gsub(/^ {8}/, '') # strip the first eight spaces of every line
          - post.it: help ---------------------------------------------------

          boom
          boom all
          boom edit
          boom help
          boom storage
          boom switch <storage>

          boom <list>
          boom <list>
          boom <list> delete

          boom <list> <name> <value>
          boom <name>
          boom <list> <name>
          boom open <name>
          boom open <list> <name>
          boom random
          boom random <list>
          boom echo <name>
          boom echo <list> <name>
          boom <list> <name> delete

          all other documentation is located at:
            https://github.com/holman/boom
        EOH
      end
    end
  end
end
