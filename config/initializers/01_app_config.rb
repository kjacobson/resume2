require 'app_config'

AppConfig.config = YAML.load_file("config/app_config.yml")[Rails.env].symbolize_keys if File.exist?("config/app_config.yml")