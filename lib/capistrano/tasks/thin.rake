namespace :deploy do
  namespace :setup do
    desc "setup thin configuration file"
    task :thin do
      on roles(:web, :app) do
        ["production", "staging"].each do |env|
          template = File.read(File.join(File.dirname(__FILE__), "../templates/thin_#{env}.yml.erb"))
          result = StringIO.new(ERB.new(template).result(binding))

          upload! result, "/home/ror/http/thin_#{env}.yml"
          execute :chmod, "644 /home/ror/http/thin_#{env}.yml"
        end
      end
    end
  end
end