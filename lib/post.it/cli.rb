module PostIt
  module CLI
    class << self
      def start(*args)
        command = message = tags = limit = nil

        args.each do |arg|
          case arg
          when 'search', 'delete', 'help', 'run'
            command ||= arg
          when /^:.+/o
            tags ||= arg.split(':')[1..-1]
          when /^-[0-9]+$/o
            limit ||= arg.to_i.abs
          else
            message ||= arg
          end
        end

        Command.delegate(command, message, tags, limit)
      end
    end
  end
end
