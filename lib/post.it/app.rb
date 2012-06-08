require File.expand_path('../../post.it.rb', __FILE__)
require 'sinatra/base'
require 'sinatra/reloader'

module PostIt
  class App < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    configure do
      set :root,          PostIt.root   + '/post.it/app'
      set :views,         settings.root + '/views'
      set :public_folder, settings.root + '/assets'
    end

    get '/' do
      @posts = PostIt::Model::Post.order_by(:created_at.desc).limit(999).all.group_by do |post|
        post.created_at.strftime('%b') + '/' + post.created_at.day.to_s
      end
      erb :index
    end

    get '/search/:tag_name' do |tag_name|
      posts = PostIt::Model::Post.order_by(:created_at.desc)

      tag = Model::Tag.find(:name => tag_name)
      if tag
        posts.filter!(:tags => tag)
      else
        redirect '/'
      end

      @posts = posts.limit(999).all.group_by do |post|
        post.created_at.strftime('%b') + '/' + post.created_at.day.to_s
      end
      erb :index
    end

    helpers do
      def tag_link_to(post)
        buff = []
        tags = post.tags.map(&:name)
        unless tags.empty?
          tags.each {|tag| buff << "<a href=\"/search/#{tag}\">##{tag}</a>"}
        end
        buff.join(' ')
      end
    end
  end
end
