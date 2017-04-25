module MessengerBot::Core

  class Commander <  MessengerBot::Support::Component

    attr_accessor :commands, :commands_map

    def handle_messages(params)
      data = MessengerBot::Core::Parser.parse_messages(params)

      data.each do |received|
        self.bot.after_message_received(received) if self.bot.respond_to?(:after_message_received)

        if received[:optin_ref]
          self.handle_command(:optin_ref, received)
        elsif received[:quick_reply_payload].present?
          payload = JSON.parse(received.delete(:quick_reply_payload))
          self.handle_command(payload.delete("command"), received.merge!(postback_payload: payload))
        elsif received[:postback_payload].present?
          payload = JSON.parse(received[:postback_payload].presence)
          self.handle_command(payload.delete("command"), received.merge!(postback_payload: payload))
        else
          self.handle_user_input(received)
        end

      end
    end

    def handle_command(command, data)
      if self.bot.respond_to?("on_command_#{command.to_s}")
        self.bot.send("on_command_#{command.to_s}", data)
      else
        raise I18n.t("messenger_bot.commander.not_implemented_command", command: command.to_s, data: data)
      end
    end

    def handle_user_input(data)
      self.bot.on_user_input(data)
    end

    def add_command(command, options = {})
      self.commands ||= {};
      self.commands_map ||= {};

      self.commands[command] = { payload: ({ command: command }.merge!(options.delete(:payload).presence || {})).to_json }
      self.commands_map[self.commands[command][:payload]] = command
    end

    def payload_for(command, args = {})
      raise MessengerBot::Errors::Commander::UnsupportedCommand.new("command #{command} doesn't exist") unless self.commands[command].present?
      if args.present?
        payload = JSON.parse(self.commands[command][:payload])
        payload.merge!(args)
        payload.to_json
      else
        self.commands[command][:payload]
      end
    end

  end

end