Apipie.configure do |config|
  config.app_name                = "SpeerTwitter"
  config.app_info                = "Created by: Stefan Wawrzyn (https://www.github.com/swawrzyn)"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate = false
end
