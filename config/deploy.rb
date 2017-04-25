# config valid only for Capistrano 3.1
lock "3.4.0"

set :production_application_dir, "prod"
set :staging_application_dir, "staging"
set :rails_env, ->{ fetch(:stage) }

set :default_env, {
  "PATH" => "/home/ror/bin:/home/ror/gem/bin:$PATH",
  "GEM_HOME" => "/home/ror/gem",
  "BUNDLE_PATH" => "/home/ror/gem",
  "RUBYLIB" => "/home/ror/lib"
}

set :bundle_binstubs, nil
set :bundle_path, "/home/ror/gem"

set :rorette_name, "groupify"
set :application, "groupify"

set :repo_url, ->{ "sociabliz@code.sociabliz.com:#{ fetch(:application) }.git" }
# set :repo_tree, "path/to/dir/to/deploy"

set :deploy_ssh_keys_dir, "/Users/florent/dev/sociabliz/deploy_ssh_keys/"
set :deploy_to, ->{ "/home/ror/site/#{fetch(:application_dir)}/" }
set :deploy_user, ->{ fetch(:rorette_name) }

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Config files are ERB templates to be uploaded to the server
set(:config_files, %w(
  thin.staging.yml
  thin.production.yml
  lighttpd.conf
))

set :system_gems, "bundler ziltoid thin"
set :bundle_bins, %w{rake rails}
set :setup_tasks, %w(gems git_user log_rotate file_upload database secrets lighttpd thin)
set :keep_releases, 5

#<<recipies>>set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }



namespace :deploy do

  desc "Start application"
  task :start do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb start"
      end
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb stop"
      end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb restart"
      end
    end
  end

  before :deploy, "deploy:check_revision" # make sure we are deploying what we think we are deploying
  before :deploy, "deploy:run_tests" # only allow a deploy with passing tests to deployed
  after :publishing, "deploy:setup:lighttpd"
  after :publishing, "deploy:setup:thin"
  after :publishing, "deploy:setup:ziltoid"
  after :publishing, :restart
  after :finishing, :cleanup

end
