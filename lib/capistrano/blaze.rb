require 'net/http'
require 'json'
require 'blaze'
require 'capistrano/blaze/version'
require 'capistrano/blaze/message'
require 'capistrano/blaze/recipes' if defined?(Capistrano::Configuration)

module Capistrano
  module Blaze

    def self.configure(&block)
      ::Blaze.configure(&block)
    end

    def self.speak(message)
      ::Blaze.speak(message)
    end

  end
end
