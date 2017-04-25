class User < ApplicationRecord
  has_many :playlists, through: :ownerships

  set_callback :create, :before, :set_fb_infos

  def fetch_fb_infos
    begin
      fields = %w(first_name last_name profile_pic locale timezone gender)
      service_url = "https://graph.facebook.com/v2.6/#{self.fb_uid}?fields=#{fields.join(",")}&access_token=#{Rails.application.secrets[:fb_page_access_token]}"
      JSON.parse(HTTPClient.get_content(service_url))
    rescue
      {}
    end
  end

  def set_fb_infos
    infos = self.fetch_fb_infos; data = {}
    infos.map { |key, value| self.send("fb_#{key}=", value) }
  end

end
