ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|

  errors = Array(instance.error_message).to_sentence
  if html_tag =~ /\A<label/
    %(#{html_tag}<span class="#{"validation-error"}" data-validation-error="1">#{errors}</span><br />).html_safe
  else
    html_tag
  end
end

module ApplicationHelper

  def error_messages_for(object, *args)
    options = args.extract_options!
    if defined?(object) && object && object.errors.any?
      collection = options[:only].present? ? object.errors.full_messages_for(options[:only]) : object.errors.full_messages
      errors = collection.inject([]) do |acc, msg|
        acc << content_tag(:li, msg.try(:html_safe))
      end
      content_tag(:ul, raw(errors.join("\n")), class: "validation-errors").try :html_safe
    end
  end

  def send_to_messenger_button(options = {})
    data_ref = options.delete(:data_ref) || "command:START"
    raise "data-ref attr should be less then 150 chars" if data_ref.length > 150
    content_for :javascripts do
      js = <<-javascript
        <script>
          window.fbAsyncInit = function() {
            FB.init({
              appId      : AppConfig.Facebook.appId,
              xfbml      : true,
              version    : 'v2.7'
            });
            FB.Event.subscribe("send_to_messenger", function(e) {
              FB.AppEvents.logEvent("sendToMessenger:#{data_ref}");
            })
          };
        </script>
      javascript
      js.html_safe
    end
    content_tag(:div, "", class: "fb-send-to-messenger", messenger_app_id: Rails.application.secrets[:fb_app_id], page_id: Rails.application.secrets[:fb_page_id], size: "xlarge", data: { ref: data_ref })
  end

  def icon_fa(icon, *args)
    options = args.present? ? args.extract_options! : {}
    attrs = { class: "fa fa-#{icon} #{options.delete(:class)}" }
    attrs.merge!(options)
    content_tag :i, "", attrs
  end

  def icon_fa_text(icon, text, start_with_text = false, *args_for_icon)
    (start_with_text ? "#{text} #{fa_icon(icon, *args_for_icon)}" : "#{fa_icon(icon, *args_for_icon)} #{text}").html_safe
  end

  def render_flash_messages(type = nil, options = {})
    html = ""
    attributes = { class: options.delete(:class).presence || "flash", id: "flash" }
    attributes[:data] = { auto_dismiss: options[:auto_dismiss].to_i } if options[:auto_dismiss].present?
    html << content_tag(:p, flash.notice.html_safe, { class: attributes.delete(:class) << " success" }.merge!(attributes)) if flash.notice
    html << content_tag(:p, flash.alert.html_safe, { class: attributes.delete(:class) << " alert" }.merge!(attributes)) if flash.alert
    html.html_safe
  end

end
