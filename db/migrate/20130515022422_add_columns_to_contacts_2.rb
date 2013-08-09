class AddColumnsToContacts2 < ActiveRecord::Migration
  def change
    add_column :contacts, :fbpic, :string
    add_column :contacts, :twpic, :string
    add_column :contacts, :lipic, :string
  end
end
