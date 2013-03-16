class User < ActiveRecord::Base
  has_many :resumes

  has_many :jobs, :dependent => :destroy
  has_many :user_skills, :dependent => :destroy
  has_many :skills, :through => :user_skills
  has_many :user_softwares, :dependent => :destroy
  has_many :softwares, :through => :user_softwares
  has_many :highlights, :dependent => :destroy
  has_many :disciplines, :dependent => :destroy
  has_many :links, :through => :resumes

  validates_uniqueness_of :email

  acts_as_authentic do |c|
    c.validate_email_field = true
  end # block optional

  def uncategorized_skills
    self.user_skills.select { |us| us.discipline_id.nil? }.map { |us| us.skill }
  end

  def novice?
    res = self.resumes
    return res.size == 0 || DateTime.now.weeks_ago(2) < res.first.created_at
  end
end