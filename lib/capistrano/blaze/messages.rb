module Capistrano
  module Blaze
    class Messages

      def self.start(context)
        new(context).start
      end

      def self.failure(context, exception)
        new(context, exception).failure
      end

      def self.success(context)
        new(context).success
      end

      def self.test(context)
        new(context).test
      end

      attr_reader :context, :exception

      def initialize(context, exception = nil)
        @context, @exception = context, exception
      end

      def start
        speak "#{user} is deploying #{what}, via `#{command}`"
      end

      def failure
        speak ":warning: #{user} failed to deploy #{what}, via `#{command}`: #{exception_message}"
      end

      def success
        speak "#{user} succesfully deployed #{what}, via `#{command}`"
      end

      def test
        speak ":heart: #{context.application}!"
      end

      private

      def exception_message
        "#{exception.to_s} (#{exception.class.inspect})"
      end

      def speak(message)
        Blaze.speak(message)
      end

      def what
        stage + context.application
      end

      def stage
        if context.respond_to?(:stage)
          "to the #{context.stage} stage of "
        else
          ""
        end
      end

      def user
        `whoami`.strip
      end

      def command
        [ 'cap', *ARGV ] * ' '
      end

    end
  end
end
