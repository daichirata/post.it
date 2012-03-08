module PostIt
  class Command
    class << self
      include PostIt::Util::Color

      def run(*args)
        command = message = tag = length = nil

        args.each do |arg|
          case arg
          when 'search', 'help'
            command ||= arg
          when /^:.+/o
            tag ||= arg
          when /^-[0-9]+$/o
            length ||= arg
          else
            message ||= arg
          end
        end

        delegate(command, message, tag, length)
      end

      def delegate(command, message, tag, length)
        return help                 if command == 'help'
        return search(tag, length)  if command == 'search' || !message
        return create(message, tag) if message

        raise ArgumentError
      end

      def create(message, tags)
        Post.create({
          :message => message,
          :tags => tags
        })

        if tags
          tags_str = with(:blue){ " Tag:"} + with(:red){"[#{Tag.parse(tags).join('][')}]" }
        end

        output do
          with(:yellow){"Create PostIt!"} + (tags_str || '')  + " #{message}"
        end
      end

      def search(tags, length)
        result = Post.find_by_tag(tags, length)

        if result
          tags_str = with(:blue){ "Tag:"} + with(:red){"[#{Tag.parse(tags).join('][')}]" }
          result.each do |m|
            output {tags_str + " " + m["message"]}
          end
        else
          output do
            with(:blue){"Tag:"} + with(:red){"[#{Tag.parse(tags).join('][')}]"} + with(:default){" is Not Find."}
          end
        end

        #output tag, length
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

      def output
        unless PostIt.silent
          STDOUT.puts yield
        end
      end
    end
  end
end
