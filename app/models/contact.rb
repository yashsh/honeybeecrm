class Contact < ActiveRecord::Base

  attr_accessible :altphone, :bClient, :bDel, :bMentor, :bSendMail, :contactsource, :contacttype, :email, :firstname, :lastname, :name, :notes, :organization, :phone, :saluation, :title, :fbuser, :twuser, :liuser, :fbpic, :twpic, :lipic 

  validates :name, :presence => true
  validates :email, :email => true
  
  #scope :starts_with, lambda {|text| where 'name like ?', text + '%'}
  scope :mailer, where("email is not null and length(email) > 0")
  
  scope :sendmail, where("email is not null and length(email) > 0 and bSendMail = true")
end
