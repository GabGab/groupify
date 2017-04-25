module MessengerBot::Support

  module Transport

    extend ActiveSupport::Concern
    include MessengerBot::Support::Logging

    def post(service, parameters)
      pastel = Pastel.new
      log("request to url: #{pastel.yellow("(POST) #{service}")} with parameters: #{pastel.yellow(parameters)}")
      response = HTTPClient.post(service,
        parameters.merge!(access_token: self.bot.fb_page_access_token).to_json,
        { "Content-Type" => "application/json" }
      )
      log(white: "response received: ", cyan: response.inspect)
      log("response body: #{pastel.green(response.body)}")
    end

    def post_to(service, to, parameters = {})
      self.post(service, parameters.merge!(recipient: { id: to.to_s }))
    end

  end

end

  # COMMANDS = {
  # }
  # WELCOME_SERVICE = "https://graph.facebook.com/v2.6/me/thread_settings?access_token=#{Rails.application.secrets[:fb_page_access_token]}&setting_type=call_to_actions&thread_state=new_thread"
  # REPLY_SERVICE = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets[:fb_page_access_token]}"
  # USER_INFO_SERVICE = "https://graph.facebook.com/v2.6/${user_id}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{Rails.application.secrets[:fb_page_access_token]}"
  #
  # def self.handle_payload_for(user, quizz, payload)
  #   if COMMANDS.values.include?(payload.to_s)
  #     self.send("handle_#{COMMANDS.invert[payload]}", user, quizz, payload)
  #   else # we're onboarded on the quizz workflow
  #     handle_quizz_answer(user, payload)
  #   end
  # end
  #
  # def self.say(to, type, options = {})
  #   puts(Pastel.new.green("[POST] #{REPLY_SERVICE}"))
  #   puts(Pastel.new.green("[POST] #{ { recipient: { id: to.to_s }, message: format_message(type, options) }.to_json }"))  unless Rails.env.production?
  #   response = HTTPClient.post(REPLY_SERVICE, {
  #     recipient: { id: to.to_s },
  #     message: format_message(type, options)
  #   }.to_json, { "Content-Type" => "application/json" })
  #   puts(Pastel.new.yellow("[Response] #{response.body}")) unless Rails.env.production?
  #   response
  # end
  #
  # def self.parse(params)
  #   params["entry"].inject([]) do |acc, entry|
  #     entry["messaging"].map do |message|
  #       if message["message"].present?
  #         acc << { sender_id: message["sender"]["id"], text: message["message"]["text"], message_id: message["message"]["mid"] }.with_indifferent_access
  #       elsif message["postback"].present?
  #         acc << { sender_id: message["sender"]["id"], payload: message["postback"]["payload"] }.with_indifferent_access
  #       end
  #     end; acc
  #   end
  # end
  #
  # def self.fetch_user_info(user_id, *fields)
  #   response = JSON.parse(HTTPClient.get_content(USER_INFO_SERVICE.gsub("${user_id}", user_id)))
  #   return response unless fields.present?
  #   keys = fields.flatten.map(&:to_s)
  #   response.select{ |k, v| keys.include?(k) }.with_indifferent_access
  # end
  #
  # def self.generic_template_element_share
  #   [{
  #     title: "Breaking News: Record Thunderstorms",
  #     subtitle: "The local area is due for record thunderstorms over the weekend. Windows FISTA",
  #     item_url: "http://thesocialclient.com",
  #     image_url: "https://tsc-sitsc-prod.s3.amazonaws.com/uploads/article_thumb_T_Livre_Blanc_Messaging.jpg",
  #     buttons: [
  #       { type: "element_share" },
  #       { type: "postback", title: "Crée un groupe", payload: "DEVELOPER_DEFINED_PAYLOAD" },
  #       {
  #         type: "web_url",
  #         url:"http://thesocialclient.com",
  #         title:"View Website"
  #       }
  #     ]
  #   }]
  # end
  #
  # def self.format_message(type, options = {})
  #   case type.to_s
  #     when "text"
  #       { text: options[:text] }
  #     when "image_from_url"
  #       { attachment: { type: "image", payload: { url: options[:url] } } }
  #     when "button"
  #       { attachment: { type: "template", payload: { template_type: type, text: options[:text], buttons: options[:buttons] } } }
  #     when "generic"
  #       { attachment: { type: "template", payload: { template_type: "generic", elements: options[:elements] } } }
  #   end
  # end