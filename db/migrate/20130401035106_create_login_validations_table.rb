class CreateLoginValidationsTable < ActiveRecord::Migration
  def change
    create_table :login_validations do |t|
      t.string :hash
      t.integer :user_id
      t.date :expiration

      t.timestamps
    end
  end
end
