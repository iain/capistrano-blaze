require 'net/http'
require 'json'
require 'ostruct'
require 'capistrano/blaze/version'
require 'capistrano/blaze/recipes' if defined?(Capistrano::Configuration)

module Capistrano
  module Blaze
    extend self

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
    end

    def failure(context, exception)
      speak ":warning: #{user} failed to deploy to the #{context.stage} stage of #{context.application}, via `#{command}`: #{exception.to_s} (#{exception.class.inspect})"
    end

    def success(context)
      speak "#{user} succesfully deployed to the #{context.stage} stage of #{context.application}, via `#{command}`"
    end

    def user
      `whoami`.strip
    end

    def test(context)
      speak ":heart: #{context.application}!"
    end

    def command
      [ 'cap', *$* ] * ' '
    end

  end
end
