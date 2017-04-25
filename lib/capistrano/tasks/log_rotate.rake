namespace :deploy do
  namespace :setup do

    desc "Init log rotate"
    task :log_rotate do
      on roles(:app) do
        unless test '[ -d "/home/ror/site/prod/log" ]'
          execute :mkdir, "-p /home/ror/site/prod/shared/log"
          within "/home/ror/site/prod" do
            execute :ln, "-s ./shared/log"
          end
        end
      end
    end

  end
end