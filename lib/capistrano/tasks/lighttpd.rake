namespace :deploy do
  namespace :setup do
    desc "Setup Lighttpd configuration"
    task :lighttpd do
      on roles(:app), in: :sequence do
        lighttpd_config_file_name = fetch(:lighttpd_config_file_name, "lighttpd.conf")
        lighttpd_config_template_path = "#{lighttpd_config_file_name}.erb"

        template = File.read(File.join(File.dirname(__FILE__), "../templates", lighttpd_config_template_path))
        result = ERB.new(template).result(binding)

        lighttpd_config_file_path = "/home/ror/http/lighttpd.conf"

        upload! StringIO.new(result), lighttpd_config_file_path
        execute :chmod, "0644", lighttpd_config_file_path
      end
    end
  end
end