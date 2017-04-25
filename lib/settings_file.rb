require "yaml"
require "active_support"
require "active_support/core_ext"

ENV["RACK_ENV"] ||= (ENV["RAILS_ENV"] || "development")

# utility class to load YAML files
class SettingsFile

  attr_accessor :settings, :settings_without_env

  def [](klass, key = nil)
    key.present? ? @settings[klass.to_sym][key] : @settings[klass]
  end

  def yaml_files
    Dir.glob(File.join(Rails.root, "config", "*.yml"))
  end

  def fetch
    if @settings_without_env.blank?
      data = {}
      yaml_files.each do |file|
        klass = File.basename(file, ".yml")
        data[klass] = YAML.load_file(file)
      end
      @settings_without_env = data.with_indifferent_access
    end
    @settings_without_env
    self.set_globals
  end

  def set_globals
    if $settings_file_without_env.blank?
      $settings_file_without_env = @settings_without_env
      puts "-> global var #{Pastel.new.yellow("$settings_file_without_env")} set!" if $settings_file_without_env.present?
    end
    if $settings_file.blank?
      data = {}
      @settings_without_env.each { |file, settings| data[file] = settings[ENV["RACK_ENV"]] }
      $settings_file = data.with_indifferent_access
      puts "-> global var #{Pastel.new.yellow("$settings_file")} set!" if $settings_file.present?
    end
  end

  def log_domains
    if $settings_file[:domains].present?
      puts "-" * 75
      $settings_file[:domains].each do |domain, customer_slug|
        puts "(domains.yml) -> #{Pastel.new.yellow(domain)} mapped to customer #{Pastel.new.yellow(customer_slug)}"
      end
      puts "-" * 75
    end
  end

end

settings = SettingsFile.new
settings.fetch
settings.set_globals
settings.log_domains