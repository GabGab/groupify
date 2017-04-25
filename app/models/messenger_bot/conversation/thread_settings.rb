module MessengerBot::Conversation

  class ThreadSettings <  MessengerBot::Support::Component

    SERVICE_URL = "https://graph.facebook.com/v2.6/me/thread_settings"
    include MessengerBot::Support::Transport

    def greeting_text(text)
      post(SERVICE_URL,
        setting_type: "greeting",
        greeting: { text: text }
      )
    end

    def get_started_button(call_to_actions)
      post(SERVICE_URL,
        setting_type: "call_to_actions",
        thread_state: "new_thread",
        call_to_actions: call_to_actions
      )
    end

    def persistent_menu(call_to_actions)
      post(SERVICE_URL,
        setting_type: "call_to_actions",
        thread_state: "existing_thread",
        call_to_actions: call_to_actions
      )
    end

    def whitelist_domain(domains)
      post(SERVICE_URL,
        setting_type: "domain_whitelisting",
        whitelisted_domains: [domains].flatten,
        domain_action_type: "add"
      )
    end

  end

end