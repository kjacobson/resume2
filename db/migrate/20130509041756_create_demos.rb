class CreateDemos < ActiveRecord::Migration
  def change
    create_table :demos do |t|
      t.integer :user_id
      t.integer :resume_id

      t.timestamps
    end
  end
end
