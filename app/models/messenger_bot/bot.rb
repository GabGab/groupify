module MessengerBot::Bot

  AUTOLOAD_CLASSES = [
    MessengerBot::Core::Parser,
    MessengerBot::Core::Commander,
    MessengerBot::Conversation::ThreadSettings,
    MessengerBot::Conversation::MessengerProfile,
    MessengerBot::Conversation::SendApi
  ]

  extend ActiveSupport::Concern
  include MessengerBot::Support::Logging

  attr_accessor :fb_page_id, :fb_page_access_token
  attr_accessor :parser, :commander, :send_api, :thread_settings, :messenger_profile

  def initialize(fb_page_id = nil, fb_page_access_token = nil)
    credentials = self.class.fb_credentials_hash
    self.fb_page_id = fb_page_id.presence || credentials[:fb_page_id]
    self.fb_page_access_token = fb_page_id.presence || credentials[:fb_page_access_token]
    AUTOLOAD_CLASSES.each{ |class_name|
      instance = class_name.new
      instance.bot = self
      self.send("#{class_name.to_s.demodulize.underscore}=", instance)
    }
    self.after_initialize
  end

  class_methods do

    def fb_credentials_hash
      Rails.application.secrets.to_h.slice(:fb_page_access_token, :fb_page_id)
    end

  end

end