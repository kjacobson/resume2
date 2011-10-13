class CreateJobSoftwares < ActiveRecord::Migration
  def self.up
    create_table :job_softwares do |t|
      t.integer :job_id
      t.integer :software_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_softwares
  end
end
