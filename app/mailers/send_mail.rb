class SendMail < ActionMailer::Base
  default :from => "ysharma@heliosedu.com"
  
  def sendmail(email, subject, body, contact)
    @contact = contact
    @body = body
    @subject = subject
    mail(:to => email, :subject => subject)
  end
  
  def reminder(email, subject, reminder)
    if email == "" || email == "default"
      email = :from
    end
    
    @rem = reminder
    mail(:to => email, :subject => subject)
  end
end
