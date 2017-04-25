module MessengerBot::Conversation

  class SendApi <  MessengerBot::Support::Component

    SERVICE_URL = "https://graph.facebook.com/v2.6/me/messages"
    include MessengerBot::Support::Transport

    def text_message(to, text)
      post_to(SERVICE_URL, to, message: { text: text })
    end

    def image_attachment(to, url_or_file)
      url_or_file.is_a?(String) ?
        post_to(SERVICE_URL, to, message: { attachment: { type: "image", payload: { url: url_or_file } } } ) :
        raise(NotImplementedError.new)
    end

    def button_template(to, text, buttons)
      post_to(SERVICE_URL, to, message: {
        attachment: {
          type: "template",
          payload: { template_type: "button", text: text, buttons: buttons }
        }
      })
    end

    def generic_template(to, elements)
      post_to(SERVICE_URL, to, message: {
        attachment: {
          type: "template",
          payload: {
            template_type: "generic",
            elements: elements
          }
        }
      })
    end

    def quick_replies(to, text, quick_replies)
      raise MessengerBot::Errors::Messenger::FieldFormat.new(:quick_replies, "items are limited to 10.") if quick_replies.length > 10
      post_to(SERVICE_URL, to, message: {
        text: text,
        quick_replies: quick_replies
      })
    end

    # https://developers.facebook.com/docs/messenger-platform/send-api-reference/sender-actions
    def sender_action(to, sender_action)
      post_to(SERVICE_URL, to, sender_action: sender_action)
    end

    def message_buttons
      @buttons ||= self.class::MessageButtons.new
    end

    class MessageButtons

      # https://developers.facebook.com/docs/messenger-platform/send-api-reference/postback-button
      def postback(title, payload)
        {
          type: "postback",
          title: title,
          payload: payload.is_a?(String) ? payload : payload.to_json
        }
      end

      # https://developers.facebook.com/docs/messenger-platform/send-api-reference/share-button
      def share
        {
          type: "element_share"
        }
      end

      def buy
        raise NoMethodError.new
      end

      # https://developers.facebook.com/docs/messenger-platform/send-api-reference/url-button
      def url(title, url, options = {})
        properties = {
          type: "web_url",
          url: url,
          title: title
        }
        properties[:webview_height_ratio] = options.delete(:webview_height_ratio) if options[:webview_height_ratio]
        properties[:messenger_extensions] = options.delete(:messenger_extensions) if options[:messenger_extensions]
        properties[:fallback_url] = options.delete(:fallback_url) if options[:fallback_url]
        properties
      end

      # https://developers.facebook.com/docs/messenger-platform/send-api-reference/call-button
      def call(title, payload)
        raise MessengerBot::Errors::Messenger::FormatError.new(:title, "has a 20 character limit") if title.length > 20
        raise MessengerBot::Errors::Messenger::FormatError.new(:payload, "starts with a \"+\"") unless payload.starts_with?("+")
        {
          type: "phone_number",
          title: title,
          payload: payload
        }
      end

      def quick_reply(content_type, options = {})
        if "text" == content_type.to_s
          raise MessengerBot::Errors::Messenger::MandatoryField.new(:title, "") unless options[:title].present?
          raise MessengerBot::Errors::Messenger::MandatoryField.new(:payload, "") unless options[:payload].present?
          raise MessengerBot::Errors::Messenger::FormatError.new(:title, "has a 20 character limit") if options[:title].length > 20
          raise MessengerBot::Errors::Messenger::FormatError.new(:payload, "has a 1000 character limit") if options[:payload].length > 1000
          {
            content_type: "text",
            title: options.delete(:title),
            payload: options.delete(:payload)
            # image_url: options.delete(:image_url)
          }
        elsif "location" == content_type.to_s
          {
            content_type: "location"
          }
        else
          raise MessengerBot::Errors::Messenger::UnsupportedParameter.new(content_type)
        end
      end

    end

  end

end