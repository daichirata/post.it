module PostIt
  module CLI
    module Output
      extend PostIt::CLI::Color

      class << self
        def create(post)
          puts with(:yellow){"Create!"} + format_tags(post.tags) + post.body
        end

        def search(posts)
          posts.each do |post|
            puts <<-EOP.gsub(/^ {14}/, '')
                #{adjust_id(m['id'])} #{tags_str}
                Date:#{m['created_at']}

                  #{m["message"]}
            EOP
          end
        end

        def delete(id)
        end

        def help
          puts <<-EOH.gsub(/^ {12}/, '')
            post.it: help ---------------------------------------------------
              post.it
              post.it <message> :<tag> -<limit>
              post.it help
          EOH
        end

        def format_tags(tags)
          buff = with(:blue){ " Tag:" }
          if tags.empty?
            buff << with(:blue){ "[none] " }
          else
            buff << with(:red){ '[' + tags.map(&:name).join('][') + '] ' }
          end
          buff
        end
      end# end class << self
    end# end Output
  end
end
