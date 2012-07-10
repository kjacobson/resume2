class CreateUserSkills < ActiveRecord::Migration
  def change
    create_table :user_skills do |t|
      t.integer :user_id, :index => true
      t.integer :skill_id, :index => true

      t.timestamps
    end
  end
end
