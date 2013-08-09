APIKEY = YAML.load_file(Rails.root.join("config", "api.yml"))[Rails.env]
APPCONFIG = YAML.load_file(Rails.root.join("config", "config.yml"))[Rails.env]

Date::DATE_FORMATS[:default] = "%m/%d/%Y"

#Linkedin gem extension to send msg
LinkedIn::Client.class_eval do
# options should be a hash like this:
# options = {:recipients => {:values => [:person => {:_path => "/people/~" }, :person =>   {:_path => "/people/USER_ID"} ]}, :subject => "Something",:body => "To read" }
  def send_message(userid, subject, body)
    path = "/people/~/mailbox"
    options = {:recipients => {:values => [:person => {:_path => "/people/" + userid } ]}, :subject => subject, :body => body }
    post(path, options.to_json, "Content-Type" => "application/json")
  end
end
