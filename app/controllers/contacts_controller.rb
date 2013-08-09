class ContactsController < ApplicationController
  include Social
  include Kaminari
  include AlphaPaging

  $refresh_social = true

  if $refresh_social
    before_filter :social_logins, :except => [:linkedin_callback,
   :linkedin_loggedin, :fb_callback, :fb_loggedin, :twitter_callback,
   :twitter_loggedin]
  end

  # GET /contacts
  # GET /contacts.json
  def index
    pageparam = "a"
    unless params[:page].nil?
      pageparam = params[:page].to_s.downcase
    end

    #@contacts =
    # Contact.order("name").starts_with(aa.chr).page(params[:page]).per(100)
    #@contacts = Contact.page(pageparam).order("name")
    @contacts = Contact.order("name")

    if $refresh_social
      linkedin_start
      fb_start
      twitter_start

      #create one big collection of all contacts
      cnns = AllConnections.new(:contacts => @contacts, :fbfriends => @fbfriends, :twfriends => @twfriends, :lifriends => @lifriends)
      @connections = cnns.connections
      #@connections = Kaminari.paginate_array(@connections).page(params[:page])
      @connections = @connections.find_all{|cnn| cnn.name.downcase.starts_with?(pageparam)}

    else
      @connections = @contacts.where("name like :prefix", prefix: "#{pageparam}%")
    #@connections = @contacts
    end

    render stream: true
    
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @contacts }
    #end
    
  end

  def mailer
    @contacts = Contact.mailer.order("name")

    respond_to do |format|
      format.html # mailer.html.erb
      format.json { render :json => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.js if request.xhr?
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.js if request.xhr?
      format.html
      format.json { render json: @contact }
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.js if request.xhr?
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.js if request.xhr?
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.js if request.xhr?
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.js if request.xhr?
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  def updateSendEmail
    ids = Array.new
    unless params[:Select].blank?
      params[:Select].each do |sel|
        if sel[1].to_i > 0
        ids << sel[0]
        end
      end

      Contact.update_all({:bSendMail => true}, ["id in (?)", ids])
    end

    #get the saved email templates
    @email_templates = EmailTemplate.count > 0 ?
      EmailTemplate.all(:order => "name") : EmailTemplate.new
  end

  def sendmail
    #if save template button clicked then save template, otherwise check if this
    # is social network msg,
    #if it is then send that msg to the recipient otherwise send email
    if params[:commit] == "Save Template"
      #save template
      if params[:id] != nil
        @emailtemplate = EmailTemplate.find(params[:id])
      saved = false
      end

      if @emailtemplate != nil
        if @emailtemplate.update_attributes()
        saved = true
        end
      else
        @emailtemplate = EmailTemplate.new()
        @emailtemplate.name = params[:name][:name]
        @emailtemplate.subject = params[:subject][:subject]
        @emailtemplate.body = params[:body][:body]
        if @emailtemplate.save
        saved = true
        end
      end

      respond_to do |format|
        if saved
          @status = "success"
          format.js { render "saveTemplate" }
        else
          @status = "error"
          format.js { render "saveTemplate", :json => @emailtemplate.errors, :status => :unprocessable_entity }
        end
      end

    return
    elsif !params[:contactid].blank? && !params[:socnetid].blank?
      #send msg to social network
      subject = params[:subject]["subject"]
      body = params[:body]["body"]
      success = false

      #linkedin
      if params[:socnet].to_s.start_with?("linkedin")
        linkedin_msg(params[:socnetid], subject, body)
      success = true
      end

      #facebook
      token = session[:fbtoken]
      if params[:socnet].to_s.starts_with?("facebook")
        fb_msg(params[:socnetid], subject + "  " + body)
      success = true
      end

      #twitter
      if params[:socnet].to_s.starts_with?("twitter")
        twitter_msg(params[:socnetid], subject + "  " + body)
      success = true
      end

      #email
      contact = Contact.find(params[:contactid])
      if !contact.nil?
        if contact.email.length > 0
          #replace field tags enclosed in {} in body with field values
          contact.attributes.each do |field|
            if body =~ /\{#{field[0]}\}/
              body = body.gsub(/\{#{field[0]}\}/, field[1])
            end
          end

        #send email
        #SendMail.sendmail(contact.Email, subject, body, contact).deliver

        success = true
        end
      end

      #send copy to user email
      if params[:sendcopy]["sendcopy"] == "1" && user_signed_in? && success
        SendMail.sendmail(current_user.email, subject, body, nil).deliver
      end

      #add to logs
      if success
        ContactLog.addLog(params[:contactid], "social", "Subject: #{subject}, Body: #{body}", "")
      end

      @socnet_message = true
    else
    #cycle thru all contacts to send mail
      body = params[:body]["body"]
      newbody = ""

      #send to all with SendEmail = true
      Contact.sendmail.each do |c|
        if c.email.length > 0
          newbody = body
          #replace field tags enclosed in {} in body with field values
          c.attributes.each do |field|
            if newbody =~ /\{#{field[0]}\}/
              newbody = newbody.gsub(/\{#{field[0]}\}/, field[1])
            end
          end

          #send email
          #SendMail.sendmail(c.Email, subject, newbody, c).deliver

          #send copy to user email
          if params[:sendcopy]["sendcopy"] == "1" && user_signed_in?
            SendMail.sendmail(current_user.email, subject, newbody, c).deliver
          end

          #add to logs
          ContactLog.addLog(c.id, "email", "Subject: #{subject}, Body: #{newbody}", c.Email)
        end
      end

    end
  end

  def social_logins
    #call login methods - if first returns true, call second because the first one is already logged in 
    gonext = fb_login
    gonext = linkedin_login if gonext
    gonext = twitter_login if gonext
  end

  def fb_callback
    fb_loggedin
    linkedin_login
  end

  def linkedin_callback
    linkedin_loggedin
    twitter_login
  #redirect_to :action => :index
  end

  def twitter_callback
    twitter_loggedin
    redirect_to :action => :index
  end

  #post msg on facebook, twitter, linkedin
  def postmessage
    if !params[:postmsg].blank?
      #msg = html_escape(params[:postmsg])
      msg = params[:postmsg]["postmsg"]
      fb_post(msg) if params[:facebook]["facebook"] == "1"
      linkedin_post(msg) if params[:linkedin]["linkedin"] == "1"
      twitter_post(msg) if params[:twitter]["twitter"] == "1"
    end

    respond_to do |format|
      format.js if request.xhr?
      format.html
    end
  end

  #play with pictures of friends and their friends and so on
  def pictures
    fb = fbobject
    @photos = []
    @myphotos = fb.get_connections("me", "photos")
    @fbfriends = fb.get_connections("me", "friends", :fields => "id,name,gender,relationship_status,first_name,last_name,picture")
    i = 0
    @fbfriends.each do |friend|
    #friends_friends = fb.get_connections(friend['id'], "friends", :fields => "id,name,gender,relationship_status,first_name,last_name,picture")
      friendsphotos = fb.get_connections(friend['id'], "photos")
      @photos << friendsphotos
      i = i + 1
      if i > 10
      break
      end
    end

    p = @photos
  end

end
