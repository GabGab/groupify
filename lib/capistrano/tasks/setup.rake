# require "yaml"
# require "erb"

namespace :deploy do
  desc "Setup deployment dependencies"
  task :setup do
    fetch(:setup_tasks, []).each do |task_name|
      invoke "deploy:setup:#{task_name}"
    end

    invoke "deploy:check"
  end
end
