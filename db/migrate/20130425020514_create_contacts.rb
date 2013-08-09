class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :title
      t.string :organization
      t.string :phone
      t.string :altphone
      t.string :firstname
      t.string :lastname
      t.string :saluation
      t.string :contacttype
      t.string :contactsource
      t.string :notes
      t.boolean :bClient
      t.boolean :bMentor
      t.boolean :bSendMail
      t.boolean :bDel

      t.timestamps
    end
  end
end
