class User < ActiveRecord::Base
  has_many :resumes

  has_many :jobs
  has_many :user_skills, :dependent => :destroy
  has_many :skills, :through => :user_skills
  has_many :user_softwares, :dependent => :destroy
  has_many :softwares, :through => :user_softwares
  has_many :highlights, :dependent => :destroy
  has_many :disciplines, :dependent => :destroy

  acts_as_authentic do |c|
    c.validate_email_field = true
  end # block optional

  def uncategorized_skills
    self.user_skills.select { |us| us.discipline_id.nil? }.map { |us| us.skill }
  end

  def links
    self.resumes.flat_map { |r| r.links }
  end
end