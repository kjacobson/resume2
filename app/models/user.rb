class User < ActiveRecord::Base
  has_many :resumes

  has_many :jobs
  has_many :user_skills
  has_many :skills, :through => :user_skills
  has_many :user_softwares
  has_many :softwares, :through => :user_softwares
  has_many :highlights

  acts_as_authentic do |c|
    c.validate_email_field = true
  end # block optional
end