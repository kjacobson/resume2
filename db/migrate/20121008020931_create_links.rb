class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.date :expiration
      t.integer :user_id
      t.integer :resume_id

      t.timestamps
    end
  end
end
