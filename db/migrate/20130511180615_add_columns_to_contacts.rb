class AddColumnsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :fbuser, :string
    add_column :contacts, :twuser, :string
    add_column :contacts, :liuser, :string
  end
end
