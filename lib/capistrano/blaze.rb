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

    def configure(opts = {})
      @config = OpenStruct.new(opts)
      yield @config if block_given?
    end

    def speak(message)
      port = @config.ssl ? 443 : 80

      req = Net::HTTP::Post.new("/room/#{@config.room_id}/speak.json")
      req.basic_auth @config.token, 'X'
      req.body = { :message => { :body => message } }.to_json
      req.content_type = "application/json"

      res = Net::HTTP.start("#{@config.account}.campfirenow.com", port, :use_ssl => @config.ssl) do |http|
        http.request(req)
      end

      if res.is_a?(Net::HTTPSuccess)
        puts "Campfire message sent!"
      else
        puts "Campfire communication failed!"
        puts res.inspect
        puts res.body.inspect
      end
    end

  end
end
