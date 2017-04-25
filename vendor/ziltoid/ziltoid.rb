#! /usr/bin/env ruby

require "ziltoid"

SHARED_PATH = "/home/ror/site/prod/shared"
CURRENT_PATH = "/home/ror/site/prod/current"
BIN_PATH = "/home/ror/bin"
GEM_BIN_PATH = "/home/ror/gem/bin"
PID_PATH = "/home/ror/http/tmp"
BUNDLE_EXEC = "#{GEM_BIN_PATH}/bundle exec"

notifiers = [
  Ziltoid::EmailNotifier.new(
    :via_options => {
      :address        => "smtp-out.bearstech.com",
      :port           => "25",
      :domain         => "groupify.appliz.com"
    },
    :subject => "[Groupify] Ziltoid message",
    :to => %w(developers@sociabliz.com),
    :from => "ziltoid@appliz.com"
  )
]
watcher = Ziltoid::Watcher.new(
  :logger => Logger.new(File.new("/home/ror/site/prod/log/ziltoid.log", "a+")),
  :progname => "Ziltoid Watcher",
  :log_level => Logger::DEBUG,
  :notifiers => notifiers
)

watcher.add(Ziltoid::Process.new("Lighty", {
  :pid_file => "#{PID_PATH}/lighttpd.pid",
  :commands => {
    :start => "#{BIN_PATH}/lighty start",
    :stop => "#{BIN_PATH}/lighty stop"
  },
  :limit => {
    :ram => 256,
    :cpu => 10
  }
}))

[4567, 4568].each do |port|
  watcher.add(Ziltoid::Process.new("Thin - production - #{port}", {
    :pid_file => "#{PID_PATH}/thin.#{port}.pid",
    :commands => {
      :start => "#{GEM_BIN_PATH}/thin start -R config.ru -C /home/ror/http/thin_production.yml",
      :stop => "#{GEM_BIN_PATH}/thin stop -R config.ru -C /home/ror/http/thin_production.yml"
    },
    :limit => {
      :ram => 256,
      :cpu => 20
    }
  }))
end

# [4565].each do |port|
#   watcher.add(Ziltoid::Process.new("Thin - staging - #{port}", {
#     :pid_file => "#{PID_PATH}/thin.#{port}.pid",
#     :commands => {
#       :start => "RAILS_ENV=staging #{GEM_BIN_PATH}/thin start -R config.ru -C /home/ror/http/thin_staging.yml",
#       :stop => "RAILS_ENV=staging #{GEM_BIN_PATH}/thin stop -R config.ru -C /home/ror/http/thin_staging.yml"
#     },
#     :limit => {
#       :ram => 256,
#       :cpu => 20
#     }
#   }))
# end

# watcher.add(Ziltoid::Process.new("Delayed Jobs", {
#   :pid_file => "#{PID_PATH}/delayed_job.pid",
#   :commands => {
#     :start => "#{CURRENT_PATH}/bin/delayed_job start --pid-dir=#{PID_PATH}",
#     :stop => "#{CURRENT_PATH}/bin/delayed_job stop --pid-dir=#{PID_PATH}"
#   },
#   :limit => {
#     :ram => 150,
#     :cpu => 10
#   }
# }))

#<<recipies>>
watcher.add(Ziltoid::Process.new("Redis", {
  pid_file: "#{PID_PATH}/redis.pid",
  commands: {
    start: "#{BIN_PATH}/redis-server #{SHARED_PATH}/config/redis.conf",
    stop: "cat #{PID_PATH}/redis.pid | xargs kill -9 | rm #{PID_PATH}/redis.pid"
  },
  limit: {
    ram: 350,
    cpu: 50
  }
}))

watcher.add(Ziltoid::Process.new("Sidekiq", {
  pid_file: "#{PID_PATH}/sidekiq.pid",
    commands: {
    start: "cd #{CURRENT_PATH} && #{BUNDLE_EXEC} sidekiq -C #{SHARED_PATH}/config/sidekiq.yml -e production -d",
    stop:  "cd #{CURRENT_PATH} && #{BUNDLE_EXEC} sidekiqctl stop #{PID_PATH}/sidekiq.pid"
  },
  limit: {
    ram: 600,
    cpu: 65
  }
}))


runnable = Ziltoid::CommandParser.parse(ARGV)
watcher.run(runnable.command.to_sym)
