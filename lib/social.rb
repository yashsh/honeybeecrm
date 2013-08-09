module Social
  require 'xmpp4r_facebook'
  
  def numeric? (str)
    Float(str) != nil rescue false
  end

  def linkedin_login
    if session[:atoken].nil? || session[:asecret].nil?
      linkedin_config = { :site => APIKEY["linkedin"]["site"],
        :authorize_path => APIKEY["linkedin"]["authpath"],
        :request_token_path => APIKEY["linkedin"]["requestpath"] + "?scope=" + APIKEY["linkedin"]["scope"],
        :access_token_path => APIKEY["linkedin"]["accesspath"] }
      client = LinkedIn::Client.new(APIKEY["linkedin"]["key"], APIKEY["linkedin"]["secret"], linkedin_config)
      request_token = client.request_token({:oauth_callback => APIKEY["linkedin"]["callback_url"]})
      session[:rtoken] = request_token.token
      session[:rsecret] = request_token.secret
      redirect_to request_token.authorize_url
    else
    #redirect_to :action => :index  
      return true
    end
  end

  def linkedin_start
    client = LinkedIn::Client.new(APIKEY["linkedin"]["key"], APIKEY["linkedin"]["secret"])
    if !session[:atoken].nil?
      client.authorize_from_access(session[:atoken], session[:asecret])
    end

    @liprofile = client.profile(:fields => %w(id first-name last-name email-address picture_url))
    @lifriends = client.connections(:fields => %w(id first-name last-name email-address picture_url headline))
  end

  def liobject
    client = LinkedIn::Client.new(APIKEY["linkedin"]["key"], APIKEY["linkedin"]["secret"])
    ato = session[:atoken]
    if !session[:atoken].nil?
      client.authorize_from_access(session[:atoken], session[:asecret])
    end

    client
  end

  def ne
    session[:rtoken] = client.request_token.token
    session[:rsecret] = client.request_token.secret
    redirect_to client.request_token.authorize_url
    client.authorize_from_access(APIKEY["linkedin"]["oauthtoken"], APIKEY["linkedin"]["oauthsecret"])
    profile = client.profile
    p = profile

  end

  def linkedin_loggedin
    client = LinkedIn::Client.new(APIKEY["linkedin"]["key"], APIKEY["linkedin"]["secret"])
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
  end

  def linkedin_post(message)
    li = liobject
    li.add_share(:comment => message)
  end

  def linkedin_msg(userid, subject, body)
    li = liobject
    li.send_message(userid, subject, body)
  end

  ##############
  def fb_authenticated?
    if session[:fbuser] != nil
    true
    else
    false
    end
  end

  def fb_user
    if fb_authenticated?
      !session[:fbtoken].nil?
    end
  end

  def fb_login
    if session[:fbtoken].nil?
      redirect_to "/auth/facebook"
    else
      return true
    end
  end

  def fb_loggedin
    auth_hash = request.env['omniauth.auth']
    #render :text => auth_hash["credentials"]["token"]

    fb = Koala::Facebook::API.new(auth_hash["credentials"]["token"])
    session[:fbtoken] = auth_hash["credentials"]["token"]
    fbobj = fb.get_object("me")
    session[:fbuser] = fbobj["id"]
  end

  def fb_start
    if !session[:fbtoken].nil?
      fb = Koala::Facebook::API.new(session[:fbtoken])
      @fbuser = fb.get_object("me")
      @fbfriends = fb.get_connections("me", "friends", :fields => "name,gender,relationship_status,first_name,last_name,picture,picture")
      session[:facebookid] = @fbuser['id']
    else
      @fbuser = nil
    end
  end

  def fbobject
    if !session[:fbtoken].nil?
      fb = Koala::Facebook::API.new(session[:fbtoken])
    #@fbuser = fb.get_object("me")
    end

    fb
  end

  def fb_reply
    fb = Koala::Facebook::API.new(session[:fbtoken])

    #go thru all wall posts in the last x hours
    posts = fb.get_connections("me", "feed")
    @posts = Array.new

    posts.each do |p|
      if p["message"]
        if p["message"].to_s.include?("birthday") || p["message"].to_s.include?("Birthday")
          #reply to birthday greetings if it has the word birthday in it
          from = p["from"]["id"]
          puts from
          msg = "Thank you " + p["from"]["name"].to_s + " for your birthday wishes!"
          pic = fb.get_picture(from, {:type => "normal"})
          begin
            @posts << {:id => from, :msg => p["message"].to_s, :pic => pic}
          rescue
          end
        end
      end
    end
  end

  def fb_postreply
    fb = Koala::Facebook::API.new(session[:fbtoken])
    post = params[:post]
    userid = params[:userid]
    token = session[:fbtoken]
    fb.put_wall_post(params[:post].to_s, {}, params[:userid].to_s, {})
  #redirect_to :action => "reply"
  end

  def fb_post(message)
    fb = fbobject
    fb.put_connections("me", "feed", :message => message)
  end

  def fb_msg(userid, subject, body)
    if session[:facebookid].nil?
      fb = fbobject
      fbuser = fb.get_object("me")
      session[:facebookid] = fbuser['id']
    end
    
    id = session[:facebookid]
    sender_chat_id = "-#{session[:facebookid]}@chat.facebook.com"
    receiver_chat_id = "-#{userid}@chat.facebook.com"
    message_body = body
    message_subject = subject

    jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
    jabber_message.subject = message_subject

    client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
    client.connect
    client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
    Facebook_Config::APP_ID, session[:fbtoken],
    Facebook_Config::SECRET), nil)
    client.send(jabber_message)
    client.close
  end

  #####################

  def twitter_login
    if session[:twtoken].nil?
      redirect_to "/auth/twitter?use_authorize=true"
    end
  end

  def twitter_loggedin
    auth_hash = request.env['omniauth.auth']
    #render :text => auth_hash["credentials"]["token"]

    tw = Twitter::Client.new(:oauth_token => auth_hash["credentials"]["token"], :oauth_token_secret => auth_hash["credentials"]["secret"])
    session[:twtoken] = auth_hash["credentials"]["token"]
    session[:twsecret] = auth_hash["credentials"]["secret"]
    twobj = tw.friends
  #session[:fbuser] = fbobj["id"]
  end

  def twitter_start
    if !session[:twtoken].nil?
      tw = Twitter::Client.new(:oauth_token => session[:twtoken], :oauth_token_secret => session[:twsecret])
      @twfriends = tw.friends
    else
      @twfriends = nil
    end
  end

  def twobject
    if !session[:twtoken].nil?
      tw = Twitter::Client.new(:oauth_token => session[:twtoken], :oauth_token_secret => session[:twsecret])
    end

    tw
  end

  def twitter_post(message)
    tw = twobject
    tw.update(message)
  end
  
  def twitter_msg(userid, message)
    tw = twobject
    #try direct msg first
    begin
    tw.direct_message_create(userid.to_i, message)
    rescue
      #didnt go thru, just tweet to user
      twuser = tw.user(userid.to_i)
      unless twuser.nil?
        #username = twuser.screen_name
        #u=twuser
        tw.update("@" + twuser.screen_name + " " + message)        
      end
    end
    

  end
end
