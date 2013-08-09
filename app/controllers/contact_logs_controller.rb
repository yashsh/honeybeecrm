class ContactLogsController < ApplicationController
  # GET /contact_logs
  # GET /contact_logs.json
  def index
    @contact_logs = ContactLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contact_logs }
    end
  end

  # GET /contact_logs/1
  # GET /contact_logs/1.json
  def show
    @contact_logs = ContactLog.where(:contactid => params[:id]).order("logdate desc")

    respond_to do |format|
      format.js if request.xhr?
      format.html # show.html.erb
      format.json { render json: @contact_logs }
    end
  end

  # GET /contact_logs/new
  # GET /contact_logs/new.json
  def new
    @contact_log = ContactLog.new
    @contact_log.contactid = params[:contactid]
    @contact_log.contactname = params[:name]
    @contact_log.email = params[:email]

    respond_to do |format|
      format.js if request.xhr?
      format.html # new.html.erb
      format.json { render json: @contact_log }
    end
  end

  # GET /contact_logs/1/edit
  def edit
    @contact_log = ContactLog.find(params[:id])
  end

  # POST /contact_logs
  # POST /contact_logs.json
  def create
    @contact_log = ContactLog.new(params[:contact_log])
    @contact_log.bSuccess = true

    respond_to do |format|
      if @contact_log.save
        format.js if request.xhr?
        format.html { redirect_to @contact_log, notice: 'Contact log was successfully created.' }
        format.json { render json: @contact_log, status: :created, location: @contact_log }
      else
        format.js if request.xhr?
        format.html { render action: "new" }
        format.json { render json: @contact_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contact_logs/1
  # PUT /contact_logs/1.json
  def update
    @contact_log = ContactLog.find(params[:id])

    respond_to do |format|
      if @contact_log.update_attributes(params[:contact_log])
        format.html { redirect_to @contact_log, notice: 'Contact log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_logs/1
  # DELETE /contact_logs/1.json
  def destroy
    @contact_log = ContactLog.find(params[:id])
    @contact_log.destroy

    respond_to do |format|
      format.html { redirect_to contact_logs_url }
      format.json { head :no_content }
    end
  end
end
