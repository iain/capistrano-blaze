require 'net/http'
require 'json'
require 'ostruct'
require 'capistrano/blaze/version'
require 'capistrano/blaze/recipes' if defined?(Capistrano::Configuration)

module Capistrano
  module Blaze
    extend self

    attr_reader :config

    def configure(rc_path = "~/.blazerc.rb")
      load_rc_file!(rc_path)
      @config ||= OpenStruct.new()
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

    def reset_configuration!
      @config = nil
    end

    private

    def load_rc_file!(rc_path)
      if !@loading_rc_file and File.exist?(File.expand_path(rc_path))
        @loading_rc_file = true
        load rc_path
      end
      @loading_rc_file = false
    end

  end
end
