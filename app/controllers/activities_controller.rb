class ActivitiesController < ApplicationController
  # GET /activities
  # GET /activities.json
  def index
    @activity = Activity.new
    @todos = Activity.todo_notcompleted
    @followups = Activity.followup_notcompleted
    @reminders = Activity.followup_reminder_notcompleted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.json
  def new
    @activity = Activity.new
    if params[:contactid]
      @contactid = params[:contactid]
      @contact = Contact.find(@contactid)
    end
    
    respond_to do |format|
      format.js if request.xhr?
      format.html # new.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(params[:activity])
    @activity.userid = current_user.id

    respond_to do |format|
      if @activity.save
        format.js if request.xhr?
        format.html { redirect_to @activity, :notice => 'Activity was successfully created.' }
        format.json { render :json => @activity, :status => :created, :location => @activity }
      else
        format.js { render :json => {:status => "error", :data => @activity.errors} } if request.xhr?
        format.html { render action: "new" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.json
  def update
    @activity = Activity.find(params[:id])
    @activity.userid = current_user.id

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.js { render :nothing => true } if request.xhr?
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render :nothing => true } if request.xhr?
        format.html { render action: "edit" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def complete
    @activity = Activity.find(params[:id])
    @activity.bCompleted = true

    respond_to do |format|
      if @activity.save
        format.js { render :nothing => true } if request.xhr?
        format.html { redirect_to @activity, :notice => 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render :nothing => true } if request.xhr?
        format.html { render :action => "edit" }
        format.json { render :json => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end



  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :no_content }
    end
  end
end
