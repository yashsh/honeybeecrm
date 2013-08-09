Twitter.configure do |config|
  config.consumer_key = APIKEY["twitter"]["consumer_key"]
  config.consumer_secret = APIKEY["twitter"]["consumer_secret"]
#config.oauth_token = APIKEY["twitter"]["oauth_token"]
#config.oauth_token_secret = APIKEY["twitter"]["oauth_secret"]
end

module Twitter_Config
  CONFIG = APIKEY["twitter"]
  KEY = CONFIG['consumer_key']
  SECRET = CONFIG['consumer_secret']

end