require 'dotenv/load'
require_relative 'fana_os/pocket_utils'
require_relative 'fana_os/obsidian_utils'

module FanaOs
  OBSIDIAN_ROOT = '/Users/fana/obsidian'.freeze

  def self.configure_mongo
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))
  end

  def self.configure_pocket
    Pocket.configure do |config|
      config.consumer_key = ENV.fetch('POCKET_CONSUMER_KEY')
    end
  end
end