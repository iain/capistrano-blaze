require 'net/http'
require 'json'
require 'ostruct'
require 'forwardable'
require 'capistrano/blaze/version'
require 'capistrano/blaze/messages'
require 'capistrano/blaze/recipes' if defined?(Capistrano::Configuration)

module Capistrano
  module Blaze
    extend self
    extend Forwardable

    def_delegators :Messages, :start, :failure, :success, :test

    def configure
      yield configuration if block_given?
    end

    def configuration
      @config ||= OpenStruct.new
    end

    def speak(message)
      port = configuration.ssl ? 443 : 80

      req = Net::HTTP::Post.new("/room/#{configuration.room_id}/speak.json")
      req.basic_auth configuration.token, 'X'
      req.body = { :message => { :body => message } }.to_json
      req.content_type = "application/json"
      req["User-Agent"] = "Capistrano::Blaze"

      res = Net::HTTP.start("#{configuration.account}.campfirenow.com", port, :use_ssl => configuration.ssl) do |http|
        http.request(req)
      end

      if res.is_a?(Net::HTTPSuccess)
        warn "Campfire message sent!"
      else
        warn "Campfire communication failed!"
        warn res.inspect
        warn res.body.inspect
      end
    end

  end
end
