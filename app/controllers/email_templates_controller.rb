class EmailTemplatesController < ApplicationController
  # GET /email_templates
  # GET /email_templates.json
  def index
    @email_templates = EmailTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @email_templates }
    end
  end

  def getTemplate
    @email_template = EmailTemplates.find(params[:id])
    et = @email_template
    respond_to do |format|
      format.js
    end
  end

  # GET /email_templates/1
  # GET /email_templates/1.json
  def show
    @email_template = EmailTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email_template }
    end
  end

  # GET /email_templates/new
  # GET /email_templates/new.json
  def new
    @email_template = EmailTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_template }
    end
  end

  # GET /email_templates/1/edit
  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  # POST /email_templates
  # POST /email_templates.json
  def create
    @email_template = EmailTemplate.new(params[:email_template])

    respond_to do |format|
      if @email_template.save
        format.html { redirect_to @email_template, notice: 'Email template was successfully created.' }
        format.json { render json: @email_template, status: :created, location: @email_template }
      else
        format.html { render action: "new" }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_templates/1
  # PUT /email_templates/1.json
  def update
    @email_template = EmailTemplate.find(params[:id])

    respond_to do |format|
      if @email_template.update_attributes(params[:email_template])
        format.html { redirect_to @email_template, notice: 'Email template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  # DELETE /email_templates/1.json
  def destroy
    @email_template = EmailTemplate.find(params[:id])
    @email_template.destroy

    respond_to do |format|
      format.html { redirect_to email_templates_url }
      format.json { head :no_content }
    end
  end
end
