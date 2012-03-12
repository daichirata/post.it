module PostIt
  module CLI
    module Format
      def output_create(message, tags)
        tags_str = adjust_tags(tags) if tags

        output do
          with(:yellow){"Create PostIt! "} + "#{message} " + (tags_str || '')
        end
      end

      def output_delete(id)
        output do
          with(:red){ "ID#{id} was deleted!" }
        end
      end

      def output_search(result)
        result.each do |m|
          tags = Tag.find_by_ids(:ids => m['tag_ids'])
          tags_str = adjust_tags(tags)

          output do
            <<-EOP.gsub(/^ {14}/, '')
              #{adjust_id(m['id'])} #{tags_str}
              Date:#{m['created_at']}

                #{m["message"]}

            EOP
          end
        end
      end

      def output_help
        output do
          <<-EOH.gsub(/^ {10}/, '')
          post.it: help ---------------------------------------------------

            post.it
            post.it <message>
            post.it <message> <:tag>
            post.it <message> <:tag> <:limit>
            post.it help
            post.it storage
            post.it switch <storage>
          EOH
        end
      end

      def output_not_found(tag)
        output do
          with(:blue){ "Tag:"} + with(:red){"[#{tag}]"} + ' is Not Found.'
        end
      end

      def adjust_id(id)
        with(:yellow){ "ID:#{format("%04d",id)}" }
      end


      def adjust_tags(tags)
        if tags
          with(:blue){ "Tag:"} + with(:red){"[#{Tag.parse(tags).join('][')}]" }
        else
          with(:blue){ "Tag:[none]" }
        end
      end

      def adjust_time(created_at)
        with(:cyan){ Time.parse(created_at).strftime('%Y/%m/%d') }
      end

      def out
        STDOUT
      end

      def output
        unless PostIt.silent
          out.puts(yield)
        end
      end
    end
  end
end
