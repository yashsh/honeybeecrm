class EmailTemplate < ActiveRecord::Base
  attr_accessible :body, :emailtype, :name, :subject
end
