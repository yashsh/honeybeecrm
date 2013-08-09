class RecurringJob 
  include Jobs::ScheduledJob
 
run_every 1.hours
 
  def perform
    puts "perform job"
    reminders = Activity.activity_reminders

    reminders.each do |rem|
      email = ""
      if !rem.userid.blank?
        u = User.find(rem.userid)
        if !u.nil?
        email = u.email
        end
      end
      #SendMail.reminder(email, "Activity reminder - " + rem.name, rem).deliver
    end
  end
end

