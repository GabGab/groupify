job_type :rake, "source /home/ror/ruby-env ; cd :path && RAILS_ENV=:environment /home/ror/gem/bin/bundle exec rake \":task\" :output"
job_type :runner, "source /home/ror/ruby-env ; cd :path && RAILS_ENV=:environment /home/ror/gem/bin/bundle exec rails runner \":task\" :output"

every 15.minute do
  runner "Klass.method"
end
