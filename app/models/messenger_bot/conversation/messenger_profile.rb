module MessengerBot::Conversation

  class MessengerProfile <  MessengerBot::Support::Component

    SERVICE_URL = "https://graph.facebook.com/v2.8/me/messenger_profile"
    include MessengerBot::Support::Transport

    def get_started_button(payload)
      post(SERVICE_URL, { get_started: { payload: payload } })
    end

    # https://developers.facebook.com/docs/messenger-platform/messenger-profile/domain-whitelisting
    def domain_whitelisting(domains)
      post(SERVICE_URL, { whitelisted_domains: [domains].flatten })
    end

    # https://developers.facebook.com/docs/messenger-platform/messenger-profile/home-url
    def chat_extension_home_url(url, webview_height_ratio, in_test, options = {})
      post(SERVICE_URL, {
        home_url: {
          url: url,
          webview_height_ratio: webview_height_ratio,
          in_test: in_test,
          webview_share_button: options[:webview_share_button] || "hide"
        }
      })
    end

  end

end