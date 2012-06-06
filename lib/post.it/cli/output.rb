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
            puts <<-EOP.gsub(/^ {16}/, '')
                ID:#{post.id} #{format_time(post.created_at)} #{format_tags(post.tags)}

                #{post.body}

            EOP
          end
        end

        def confirm_delete?(post)
          puts <<-EOC.gsub(/^ {12}/, '')
            ID:#{post.id} #{post.body}
            #{with(:red){ 'Are you sure you want to delete? (Y/n)' }}
          EOC
          case STDIN.gets.chomp
          when '', 'Y', 'y'
            return true
          when 'n', 'N'
            return false
          else
            puts with(:blue){ 'Input is abnormal.' }
            return false
          end
        end

        def delete(post)
          puts "ID:#{post.id} has been deleted."
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
          buff = "Tag:"
          if tags.empty?
            buff << with(:blue){ "[none] " }
          else
            buff << with(:red){ '[' + tags.map(&:name).join('][') + '] ' }
          end
          buff
        end

        def format_time(time)
           'Date:' + time.strftime('%Y/%m/%d %H:%M')
        end

      end# end class << self
    end# end Output
  end
end
