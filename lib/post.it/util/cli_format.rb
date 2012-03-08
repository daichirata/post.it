module PostIt
  module Util
    module CLIFormat

      def puts_create(message, tags)
        tags_str = adjust_tags(tags) if tags

        output do
          with(:yellow){"Create PostIt! "} + (tags_str || '')  + "#{message}"
        end
      end

      def puts_search(result, tags)
        tags_str = tags ? adjust_tags(tags) : ''
        result.each do |m|
          output {tags_str + m["message"]}
        end
      end

      def puts_tag_notfound(tag)
        output do
          with(:blue){ "Tag:"} + with(:red){"[#{tag}]"} + ' is Not Found.'
        end
      end

      def adjust_tags(tags)
        with(:blue){ "Tag:"} + with(:red){"[#{Tag.parse(tags).join('][')}] " }
      end

      def output
        unless PostIt.silent
          STDOUT.puts '> ' + yield
        end
      end
    end
  end
end
