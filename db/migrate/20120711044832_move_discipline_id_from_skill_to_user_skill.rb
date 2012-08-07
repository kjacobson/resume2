class MoveDisciplineIdFromSkillToUserSkill < ActiveRecord::Migration
  def up
    remove_column :skills, :discipline_id
    add_column :user_skills, :discipline_id, :integer, :index => true
  end

  def down
    remove_column :user_skills, :discipline_id
    add_column :skills, :discipline_id, :integer, :index => true
  end
end
