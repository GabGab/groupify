module MessengerBot::Core

  class Parser <  MessengerBot::Support::Component

    def self.parse_messages(params)
      params["entry"].inject([]) do |acc, entry|
        entry["messaging"].map do |message|
          if message["message"].present? && message["message"]["quick_reply"].present?
            acc << parse_quick_reply(message)
          elsif message["message"].present? && message["message"]["text"].present?
            acc << parse_text(message)
          elsif message["message"].present? && message["message"]["attachments"].present?
            message["message"]["attachments"].each { |attachment| acc << parse_attachment(message, attachment) }
          elsif message["postback"].present?
            acc << parse_postback(message)
          elsif message["optin"].present?
            acc << parse_optin(message)
          end
        end; acc
      end
    end

    private

    def self.parse_quick_reply(message)
      {
        sender_id: message["sender"]["id"],
        recipient_id: message["recipient"]["id"],
        quick_reply_payload: message["message"]["quick_reply"]["payload"],
        message_mid: message["message"]["mid"],
        message_text: message["message"]["text"],
        type: "quick_reply"
      }.with_indifferent_access
    end

    def self.parse_text(message)
      { sender_id: message["sender"]["id"],
        recipient_id: message["recipient"]["id"],
        message_text: message["message"]["text"],
        message_mid: message["message"]["mid"],
        type: "text"
      }.with_indifferent_access
    end

    def self.parse_attachment(message, attachment)
      { sender_id: message["sender"]["id"],
        recipient_id: message["recipient"]["id"],
        message_mid: message["message"]["mid"],
        attachment_payload: attachment["payload"],
        type: attachment["type"]
      }.with_indifferent_access
    end

    def self.parse_postback(message)
      { sender_id: message["sender"]["id"],
        recipient_id: message["recipient"]["id"],
        postback_payload: message["postback"]["payload"],
        type: "postback"
      }.with_indifferent_access
    end

    def self.parse_optin(message)
      { sender_id: message["sender"]["id"],
        recipient_id: message["recipient"]["id"],
        optin_ref: message["optin"]["ref"],
        type: "optin"
      }.with_indifferent_access
    end

  end

end