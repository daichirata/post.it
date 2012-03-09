$:.push File.expand_path(File.dirname(__FILE__))

require 'sqlite3'
require 'multi_json'
require 'post.it/storage'
require 'post.it/storage/sqlite'
require 'post.it/model'
require 'post.it/model/base'
require 'post.it/model/post'
require 'post.it/model/tag'
require 'post.it/util/color'
require 'post.it/util/cli_format'
require 'post.it/util/sql_builder'
require 'post.it/config'
require 'post.it/command'

module PostIt
  VERSION = '0.0.1'

  class << self
    attr_accessor :color, :debug, :silent

    def config
      @config ||=
        PostIt::Config.new
    end

    def storage
      @storage ||=
        PostIt::Storage.resolve config['storage']
    end

    def default_limit
      15
    end
  end

  self.color = true
  self.debug = true
  self.silent = false
end

