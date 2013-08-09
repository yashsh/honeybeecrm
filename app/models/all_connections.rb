class AllConnections
  attr_reader :connections
  def initialize(options = {})
    @connections = []
    @contacts = nil
    @save_to_db = true

    if !options[:contacts].nil?
      @contacts = options[:contacts]
      unless @contacts.blank?
        @contacts.each do |c|
          add(c.name, c.email, :id => c.id, :fbuser => c.fbuser, :fbpic => c.fbpic, :twuser => c.twuser, :twpic => c.twpic,
              :liuser => c.liuser, :lipic => c.lipic)
        end
      end
    end

    if !options[:fbfriends].nil?
      fbfriends = options[:fbfriends]
      unless fbfriends.blank?
        fbfriends.each do |f|
          add(f['name'], '', :fbuser => f['id'], :fbpic => f['picture']['data']['url'])
        end
      end
    end

    if !options[:twfriends].nil?
      twfriends = options[:twfriends]
      unless twfriends.blank?
        twfriends.each do |t|
          add(t['name'], '', :twuser => t['id'].to_s, :twpic => t['profile_image_url'])
        end
      end
    end

    if !options[:lifriends].nil?
      lifriends = options[:lifriends]
      unless lifriends.blank?
        lifriends.all.each do |l|
          add(l.first_name + ' ' + l.last_name, '', :liuser => l.id, :lipic => l.picture_url)
        end
      end
    end

    #sort
    @connections = @connections.sort_by{|c| c.name}
    saveConnections
  end

  def add(name, email, options = {})
    #check if it already exists in the connections array we are building here
    if !includes?(name)
      cn = Connection.new
      cn.name = name
      cn.email = email
      cn.fbuser = options[:fbuser].squish unless options[:fbuser].blank?
      cn.twuser = options[:twuser].squish unless options[:twuser].blank?
      cn.liuser = options[:liuser].squish unless options[:liuser].blank?
      cn.fbpic = options[:fbpic] unless options[:fbpic].blank?
      cn.twpic = options[:twpic] unless options[:twpic].blank?
      cn.lipic = options[:lipic] unless options[:lipic].blank?
      cn.id = options[:id] unless options[:id].nil?

    @connections << cn
    else
    #exists, just update the connections array
      cn = @connections.detect{|cnn| cnn.name.downcase.squish == name.downcase.squish}
      cn.fbuser = options[:fbuser].squish unless options[:fbuser].blank?
      cn.twuser = options[:twuser].squish unless options[:twuser].blank?
      cn.liuser = options[:liuser].squish unless options[:liuser].blank?
      cn.fbpic = options[:fbpic] unless options[:fbpic].blank?
      cn.twpic = options[:twpic] unless options[:twpic].blank?
      cn.lipic = options[:lipic] unless options[:lipic].blank?
      cn.id = options[:id] unless options[:id].nil?

    end

    return true
  end

  def includes? (name)
    exists = false

    @connections.each do |c|
      if c.name.downcase.squish == name.downcase.squish
      exists = true
      break
      end
    end

    return exists
  end

  def saveConnections
    if @save_to_db
      #add connections to Contact table in db
      @connections.each do |cn|
        if cn.id.nil?
          #not in contacts so insert
          #add new contact record
          c = Contact.new
        c.name = cn.name
        c.email = cn.email
        c.fbuser = cn.fbuser
        c.twuser = cn.twuser
        c.liuser = cn.liuser
        c.fbpic = cn.fbpic
        c.twpic = cn.twpic
        c.lipic = cn.lipic
        c.save
        else
          c = Contact.find(cn.id)
          if c.nil?
            #not in contacts so insert
            #add new contact record
            c = Contact.new
          c.name = cn.name
          c.email = cn.email
          c.fbuser = cn.fbuser
          c.twuser = cn.twuser
          c.liuser = cn.liuser
          c.fbpic = cn.fbpic
          c.twpic = cn.twpic
          c.lipic = cn.lipic
          c.save
          else
          c.email = cn.email
          c.fbuser = cn.fbuser
          c.twuser = cn.twuser
          c.liuser = cn.liuser
          c.fbpic = cn.fbpic
          c.twpic = cn.twpic
          c.lipic = cn.lipic
          c.save

          end
        end
      end
    end
  end

  def saveToDB
    if @save_to_db
      #add connections to Contact table in db
      if !options[:fbuser].blank?
        #find contact by fbuser; if found, do nothing; if not, find contact by
        # name and update fbuser; otherwise add new record
        con = Contact.find_by_fbuser(options[:fbuser].squish)
        if con.nil?
          con = Contact.find_by_name(name)
          if con.nil?
            #add new contact record
            c = Contact.new
            c.name = name
            c.email = email
            c.fbuser = options[:fbuser].squish
          c.save
          else
          #update contact record with fbuser
            con.fbuser = options[:fbuser].squish
          con.save
          end
        end
      end

      if !options[:twuser].blank?
        #find contact by twuser; if found, do nothing; if not, find contact by
        # name and update twuser; otherwise add new record
        con = Contact.find_by_twuser(options[:twuser].squish)
        if con.nil?
          con = Contact.find_by_name(name)
          if con.nil?
            #add new contact record
            c = Contact.new
            c.name = name
            c.email = email
            c.twuser = options[:twuser].squish
          c.save
          else
          #update contact record with twuser
            con.twuser = options[:twuser].squish
          con.save
          end
        end
      end

      if !options[:liuser].blank?
        #find contact by liuser; if found, do nothing; if not, find contact by
        # name and update liuser; otherwise add new record
        con = Contact.find_by_liuser(options[:liuser].squish)
        if con.nil?
          con = Contact.find_by_name(name)
          if con.nil?
            #add new contact record
            c = Contact.new
            c.name = name
            c.email = email
            c.liuser = options[:liuser].squish
          c.save
          else
          #update contact record with liuser
            con.liuser = options[:liuser].squish
          con.save
          end
        end
      end
    end

  end

  def getConnection (contact)
    exists = false
    connection = nil

    @connections.each do |c|
      if c.name.downcase.squish == contact.name.downcase.squish || c.fbuser.squish == contact.fbuser.squish || c.twuser.squish == contact.twuser.squish || c.liuser.squish == contact.liuser.squish
      exists = true
      connection = c
      break
      end
    end

    return connection
  end

  protected

  class Connection
    attr_accessor :id, :name, :email, :fbuser, :twuser, :liuser, :fbpic, :twpic, :lipic
  end

end