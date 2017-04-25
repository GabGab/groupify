class MessengerBot::Errors

  module Commander
    class UnsupportedCommand < StandardError; end
  end

  module Messenger

    class UnsupportedParameter

      attr_accessor :unsupported_parameter

      def initialize(unsupported_parameter)
        self.unsupported_parameter = unsupported_parameter
      end

    end
    class FieldError < StandardError

      attr_accessor :field, :msg

      def initialize(field, msg)
        super("[#{field}] #{msg}")
      end

    end
    class FieldFormat < FieldError; end
    class FieldPresence < FieldError; end

  end

end