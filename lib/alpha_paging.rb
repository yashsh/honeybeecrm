
# Hacks round some internals to use alphabet stuff rather than LIMIT/OFFSET
module AlphaPaging
  include Kaminari::ActiveRecordRelationMethods
  include Kaminari::PageScopeMethods

  # We don't care about setting a limit, so just pass back the current scope
  def per(num)
    scoped
  end

  # 26 letters in the alphabet, or at least last time I checked
  def num_pages
    26
  end

  delegate :count, :to => :klass
  attr_accessor :current_page, :total_count, :limit_value
end

Contact.class_eval do
  scope :starts_with, lambda { |text| where 'name LIKE ?', text + '%' }
  scope :page, lambda { |letter| 
    # Change the paging behaviour
    extend AlphaPaging
    # Need to track page number manually as limit_value and offset_value are part of AR's Arel bindings
    self.current_page = letter.downcase.ord - 'a'.ord + 1 #calculate based on ord value
    #self.total_count = 100
    #self.limit_value = 100
    # Call the scope that deals with alphabety stuff
    #starts_with(('A'.ord + num.to_i - 1).chr)
    starts_with(letter)
  }
end

#Track.page(3).total_count


