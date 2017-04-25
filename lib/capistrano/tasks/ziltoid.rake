namespace :deploy do
  namespace :setup do
    desc "setup Ziltoid configuration file"
    task :ziltoid do
      on roles(:web, :app, :db) do
        execute :cp, "#{current_path}/vendor/ziltoid/ziltoid.rb /home/ror/ziltoid.rb"
        execute :chmod, "644 /home/ror/ziltoid.rb"
        execute :chmod, "+x /home/ror/ziltoid.rb"
      end
    end
  end
end