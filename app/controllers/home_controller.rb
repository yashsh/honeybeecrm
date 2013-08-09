class HomeController < ApplicationController
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
end
