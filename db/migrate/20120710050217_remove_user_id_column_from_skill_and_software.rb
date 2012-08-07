class RemoveUserIdColumnFromSkillAndSoftware < ActiveRecord::Migration
  def up
    remove_column :skills, :user_id
    remove_column :softwares, :user_id
  end

  def down
    remove_column :softwares, :user_id, :integer
    remove_column :skills, :user_id, :integer
  end
end
