set :test_log, File.expand_path(File.join("log/capistrano.test.log"))

namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_tests do
    system "touch #{fetch(:test_log)}"
    puts "--> Running tests, please wait…"
    unless system "bundle exec rake > #{fetch(:test_log)} 2>&1" #' > /dev/null'
      puts "--> Tests failed. Run `cat #{fetch(:test_log)}` to see what went wrong."
      exit
    else
      puts "--> Tests passed"
      system "rm #{fetch(:test_log)}"
    end
  end
end
