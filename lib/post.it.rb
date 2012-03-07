$:.push File.expand_path(File.dirname(__FILE__))

module PostIt
  VERSION = '0.0.1'

  class << self
    attr_accessor :models

    def config
      @config ||= PostIt::Config.new
    end

    def storage
      @storage ||= PostIt::Storage.resolve(config['storage'])
    end

    def debug
      false
    end

    def silent
      false
    end
  end
end

require 'arel'
require 'sqlite3'
require 'multi_json'
require 'post.it/storage'
require 'post.it/storage/base'
require 'post.it/storage/sqlite'
require 'post.it/config'
require 'post.it/color'
require 'post.it/command'
require 'post.it/post'
require 'post.it/tag'

# for debugg
# p PostIt.storage

