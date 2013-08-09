class Activity < ActiveRecord::Base  
  attr_accessible :activitytype, :actualfinish, :actualstart, :bCompleted, :bDel, :completeby, :contactid, :description, :name, :targetfinish, :targetstart, :userid

  scope :todo_notcompleted, where("activitytype = ? and (bCompleted is null or bCompleted = ?)", "todo", false)
  scope :followup_notcompleted, where("activitytype = ? and (bCompleted is null or bCompleted = ?)", "followup", false)
  scope :reminder_notcompleted, where("activitytype = ? and (bCompleted is null or bCompleted = ?)", "reminder", false)
  scope :followup_reminder_notcompleted, where("activitytype in (?, ?) and (bCompleted is null or bCompleted = ?)", "followup", "reminder", false)

  scope :activity_reminders, where("(bCompleted is null or bCompleted = ?) and (targetstart = ? or targetfinish <= ?)", false, Date.today, Date.today - APPCONFIG["remind_before_days"])

end
