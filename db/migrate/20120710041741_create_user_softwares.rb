class CreateUserSoftwares < ActiveRecord::Migration
  def change
    create_table :user_softwares do |t|
      t.integer :user_id, :index => true
      t.integer :software_id, :index => true

      t.timestamps
    end
  end
end
