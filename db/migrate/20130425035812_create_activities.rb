class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :contactid
      t.integer :userid
      t.string :name
      t.string :activitytype
      t.string :description
      t.datetime :targetstart
      t.datetime :targetfinish
      t.datetime :actualstart
      t.datetime :actualfinish
      t.integer :completeby
      t.boolean :bCompleted
      t.boolean :bDel

      t.timestamps
    end
  end
end
