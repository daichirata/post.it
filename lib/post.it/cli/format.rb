module PostIt
  module CLI
    module Format
      def output_create(post)
        output do |term|
          term << with(:yellow){ "Create PostIt!" }
          term << post.body
          term << format_tags(post.tags)
        end
      end

      def format_tags(tags)
      end

      def output_delete(id)
        output do
          with(:red){ "ID#{id} was deleted!" }
        end
      end

      def output_search(result)
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

      def output(&block)
        PostIt::CLI::Terminal.out(&block)
      end
    end
  end
end
