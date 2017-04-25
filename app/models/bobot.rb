class Bobot

  include MessengerBot::Bot
  # include ActionView::Helpers::DateHelper
  ALLOWED_OPTIN_KEYS = %w(command)

  attr_accessor :current_user, :app_host

  # setup

  def after_initialize
    # persistant menu commands
    @commander.add_command(:help)
    # Bot logic related commands
    @commander.add_command(:sample_1)
    @commander.add_command(:sample_2)
    # on free inputs
    # @commander.add_command(:user_input_confirmation)
  end

  def after_message_received(data)
    log "received message: #{Pastel.new.yellow("#{data.inspect}")} with payload: #{Pastel.new.yellow(data[:postback_payload])}"
    self.current_user = User.where(fb_uid: data[:sender_id]).first_or_create
  end

  def on_command_start(data)
    @send_api.button_template(@current_user.fb_uid, I18n.t("bobot.commands.start.text"), [
      @send_api.message_buttons.url(I18n.t("bobot.commands.start.button.text"), app_router.new_playlist_url, {
        webview_height_ratio: "tall",
        messenger_extensions: true
      })
    ])
  end

  def on_command_help(data)
    @send_api.text_message(@current_user.fb_uid, I18n.t("bobot.commands.help.text_1"))
    @send_api.button_template(@current_user.fb_uid, I18n.t("bobot.commands.help.text_2"), [
      @send_api.message_buttons.postback(I18n.t("bobot.commands.help.button_1.text"), @commander.payload_for(:sample_1)),
      @send_api.message_buttons.postback(I18n.t("bobot.commands.help.button_2.text"), @commander.payload_for(:sample_2))
    ])
  end

  def on_command_sample_1(data)
    @send_api.text_message(@current_user.fb_uid, I18n.t("bobot.commands.sample_1.text"))
  end

  def on_command_sample_2(data)
    @send_api.text_message(@current_user.fb_uid, I18n.t("bobot.commands.sample_2.text"))
  end

  def on_user_input(data)
    @send_api.text_message(@current_user.fb_uid, "You have typed something !")
    # a call can be made to on_command_user_input_confirmation to have the user confirm his entry
  end

  # text message handling

  # In case you need to have confirmation after on_user_input
  # def on_command_user_input_confirmation(data)
  #   if data[:postback_payload][:status] == "answer_confirmed"
  #     @send_api.text_message(@current_user.fb_uid, I18n.t("missions.current.already_answered", user_name: user_name))
  #   else
  #     @send_api.text_message(@current_user.fb_uid, I18n.t("missions.current.user_input_confirmation.answer_cancelled.text", mission_description: mission.description))
  #   end
  # end

  # single entry point after clicks on send_to_messenger button
  def on_command_optin_ref(data)
    command = parse_optin_ref(data[:optin_ref])[:command]

    if command == "START"
      @send_api.text_message(@current_user.fb_uid, I18n.t("bobot.optin_ref.start.text", user_name: user_name))
    elsif command == "SOMETHING_ELSE"
      @send_api.text_message(@current_user.fb_uid, I18n.t("bobot.optin_ref.sth.text", user_name: user_name))
    end
  end

  private

    def parse_optin_ref(optin_ref)
      # takes an optin ref as "command:START/key:value" and returns { command: "START", key: "value" }
      hash = optin_ref.split("/").inject({}) do |acc, payload_couple|
        payload_key, payload_value = payload_couple.split(":")
        acc[payload_key] = payload_value if ALLOWED_OPTIN_KEYS.include?(payload_key)
        acc
      end.with_indifferent_access

      hash
    end

    def set_get_started_button
      @messenger_profile.get_started_button("START")
    end

    def set_persistent_menu
      @thread_settings.persistent_menu([
        @send_api.message_buttons.postback(I18n.t("bobot.persistant_menu.help.text"), @commander.payload_for(:help)),
        @send_api.message_buttons.url("Un lien externe", "https://www.facebook.com")
      ])
    end

    def set_chat_extension_home_url
      @messenger_profile.chat_extension_home_url(app_router.new_playlist_url, "tall", true)
    end

    def app_host
      Rails.application.secrets[:host]
    end

    def app_router
      Rails.application.routes.url_helpers
    end

    def user_name(user = nil)
      (user.presence || @current_user).fb_first_name || "{{user_first_name}}"
    end

end