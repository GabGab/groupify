# require "yaml"
# require "erb"

namespace "deploy" do
  namespace :setup do
    desc "Install application-independent required gems"
    task :gems do
      on roles(:app, :web), in: :sequence do
        system_gems = fetch(:system_gems).split(" ")
        system_gems.each do |gem_name|
          begin
            capture(:gem, "list -i #{gem_name}")
          rescue SSHKit::Command::Failed
            execute :gem, "install", gem_name
          end
        end
      end
    end
  end
end