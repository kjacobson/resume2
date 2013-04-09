require 'app_config'

if File.exist?("config/app_config.yml")
  AppConfig.config = YAML.load_file("config/app_config.yml")[Rails.env].symbolize_keys
else
  AppConfig.config = {
    :host => APP_CONFIG['host']
  }
end