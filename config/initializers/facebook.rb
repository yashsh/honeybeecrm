# config/initializers/facebook.rb

module Facebook_Config
  CONFIG = APIKEY["facebook"]
  APP_ID = CONFIG['app_id']
  SECRET = CONFIG['secret_key']
  CALLBACK_URL = CONFIG['callback_url']
  PERMS = CONFIG['perms']
  
end

Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
      when 0, 1
        raise "application id and/or secret are not specified in the config" unless Facebook::APP_ID && Facebook::SECRET
        initialize_without_default_settings(Facebook::APP_ID.to_s, Facebook::SECRET.to_s, Facebook::CALLBACK_URL.to_s)
      when 2, 3
        initialize_without_default_settings(*args)
    end
  end

  alias_method_chain :initialize, :default_settings
end