Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Facebook_Config::APP_ID, Facebook_Config::SECRET, {:scope => Facebook_Config::PERMS}
  provider :twitter, Twitter_Config::KEY, Twitter_Config::SECRET
end