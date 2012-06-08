$:.push File.expand_path(File.dirname(__FILE__))

require 'sequel'
require 'logger'

require 'post.it/model'
require 'post.it/model/post'
require 'post.it/model/tag'
require 'post.it/model/tagging'
require 'post.it/cli'
require 'post.it/cli/color'
require 'post.it/cli/output'
require 'post.it/cli/command'

module PostIt
  VERSION = '0.0.2'

  class << self
    attr_accessor :root, :color, :debug, :silent

    def root
      @root ||= File.expand_path(File.dirname(__FILE__))
    end
  end

  module Model
    #DB.loggers << Logger.new(STDOUT)
  end
end



