module PostIt
  class Command
    class << self
      include PostIt::Util::Color
      include PostIt::Util::CLIFormat

      def run(*args)
        command = message = tag = limit = nil

        args.each do |arg|
          case arg
          when 'search', 'delete', 'help'
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
        return delete(message)      if command == 'delete'
        return search(tag, limit)   if command == 'search' || !message
        return create(message, tag) if message

        raise ArgumentError
      end

      def create(message, tags)
        Post.create(:message => message, :tags => tags)
        output_create(message, tags)
      end

      def search(tags, limit)
        result = Post.find_by_tag(:tags => tags, :limit => limit)
        case result
        when Array
          output_search(result)
        when String
          output_not_found(result)
        end
      end

      def delete(id)
        Post.delete(:id => id)
        output_delete(id)
      end

      def help
        output_help
      end
    end
  end
end
