namespace :deploy do
  namespace :setup do
    task :database do
      on roles(:app, :db) do

        db_password = capture('cat .my.cnf | grep "pass = " | cut -d= -f 2').chomp
        db_username = capture('cat .my.cnf | grep "user = " | cut -d= -f 2').chomp
        db_host = capture('cat .my.cnf | grep "host = " | cut -d= -f 2').chomp

        db_config = StringIO.new(ERB.new(<<-EOF
production:
  adapter: mysql2
  encoding: utf8mb4
  collation: utf8mb4_bin
  database: #{db_username}_prod
  username: #{db_username}
  password: #{db_password}
  host: #{db_host}
staging:
  adapter: mysql2
  encoding: utf8mb4
  collation: utf8mb4_bin
  database: #{db_username}_dev
  username: #{db_username}
  password: #{db_password}
  host: #{db_host}

EOF
).result(binding))

        execute :mkdir, "-p #{shared_path}/config"
        upload! db_config, "#{shared_path}/config/database.yml"
        execute :chmod, "644 #{shared_path}/config/database.yml"
      end
    end
    
  end
end