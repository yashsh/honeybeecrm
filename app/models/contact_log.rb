class ContactLog < ActiveRecord::Base
  attr_accessible :bSuccess, :contactid, :contactname, :email, :logdate, :logdetail, :logtype

  before_save :format_values
  def format_values
    fmt = I18n.t "time.formats.default"
    dt = Time.strptime(@attributes['logdate'], fmt)
    self.logdate = dt
  end

  #add quick log from any controller
  def self.addLog(contactid, logtype, logdetail, email)
    if contactid.to_i > 0
      contact = Contact.find(contactid)
      if !contact.nil?
        log = self.new
        log.contactid = contact.id
        log.contactname = contact.name
        log.email = email
        log.logdate = I18n.l(Time.now)
      log.logdetail = logdetail
      log.logtype = logtype
      log.bSuccess = true
      log.save
      else
      return false
      end
    else
    return false
    end
  end
end
