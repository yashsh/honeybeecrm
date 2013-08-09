class CreateContactLogs < ActiveRecord::Migration
  def change
    create_table :contact_logs do |t|
      t.integer :contactid
      t.string :contactname
      t.string :email
      t.datetime :logdate
      t.string :logtype
      t.string :logdetail
      t.boolean :bSuccess

      t.timestamps
    end
  end
end
