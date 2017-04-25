class PagesController < ApplicationController

  protect_from_forgery with: :null_session, only: :webhook
  before_action :set_bot

  def home
  end

  def playlist
    
  end

  def webhook
    if self.request.get?
      render text: verify_webhook_token
    elsif self.request.post?
      data = MessengerBot::Core::Parser.parse_messages(params).first
      # => [{"sender_id"=>"1213916438647123", "recipient_id"=>"567225763474975", "postback_payload"=>"START", "type"=>"postback"}]
      if data && data["type"] == "postback" && data["postback_payload"] == "START"
        @bot.current_user = User.where(fb_uid: data[:sender_id]).first_or_create
        @bot.on_command_start(data)
      else
        @bot.commander.handle_messages(params)
      end
      render text: nil
    end
  end

  private

    def set_bot
      @bot = Bobot.new
    end

    def verify_webhook_token
      params["hub.verify_token"] == Rails.application.secrets[:fb_webhook_verify_token] ? params["hub.challenge"] :  t(".get_request.service_ko")
    end

end