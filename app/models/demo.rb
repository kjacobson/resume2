class Demo < ActiveRecord::Base
  attr_accessible :resume_id, :user_id
  validates_presence_of :user_id
  validates_presence_of :resume_id
  validates_uniqueness_of :resume_id
end
