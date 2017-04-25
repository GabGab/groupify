namespace :deploy do
  namespace :setup do
    desc "setup secrets configuration file"
    task :secrets do
      on roles(:app, :db) do
        secrets_config = StringIO.new(ERB.new(<<-EOF
production:
  secret_key_base: #{`rake secret`}

staging:
  secret_key_base: #{`rake secret`}
EOF
).result(binding))

        execute :mkdir, "-p #{shared_path}/config"
        upload! secrets_config, "#{shared_path}/config/secrets.yml"
        execute :chmod, "644 #{shared_path}/config/secrets.yml"
      end
    end
    
  end
end