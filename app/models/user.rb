class User < ActiveRecord::Base
  has_many :resumes

  has_many :jobs
  has_many :skills
  has_many :softwares
  has_many :highlights

  acts_as_authentic do |c|
    c.validate_email_field = true
  end # block optional
end