class UserSoftware < ActiveRecord::Base 
  validates_presence_of :user_id
  validates_presence_of :software_id

  belongs_to :user
  belongs_to :software
end
