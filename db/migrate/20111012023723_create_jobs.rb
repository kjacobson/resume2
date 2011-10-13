class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :user_id
      t.string :title
      t.string :employer
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year
      t.string :project
      t.string :url
      t.string :status
      t.text :short_desc
      t.text :long_desc
      t.string :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
