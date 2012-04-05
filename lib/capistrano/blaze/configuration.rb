module Capistrano
  module Blaze

    class Configuration

      attr_accessor :account, :room_id, :token, :ssl

      def []=(option, value)
        send "#{option}=", value
      end

      def [](option)
        send option
      end

      def validate!
        %w(account room_id token).each do |option|
          if send(option).nil?
            fail MissingOption.new(option)
          end
        end
      end

      class MissingOption < RuntimeError

        def initialize(option)
          @option = option
        end

        def to_s
          "Please specify the #{@option} option"
        end

      end
    end

  end
end
