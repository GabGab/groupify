namespace :deploy do
  namespace :setup do
    desc "Upload SSH keys for Git"
    task :git_user do
      on roles(:app) do
        upload! "#{fetch(:deploy_ssh_keys_dir)}id_rsa.pub",  "/home/ror/.ssh"
        upload! "#{fetch(:deploy_ssh_keys_dir)}id_rsa",      "/home/ror/.ssh"
        upload! "#{fetch(:deploy_ssh_keys_dir)}known_hosts", "/home/ror/.ssh"

        execute :chmod, "600 /home/ror/.ssh/id_rsa"
        execute :chmod, "644 /home/ror/.ssh/id_rsa.pub"
        execute :chmod, "600 /home/ror/.ssh/known_hosts"
      end
    end
  end
end