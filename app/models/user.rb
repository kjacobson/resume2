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
  # it's probably has_one, but we'll see...
  has_many :login_validations

  validates_uniqueness_of :email
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  def self.generate_hash
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
    string  =  (0..16).map{ o[rand(o.length)]  }.join;

    md5 = Digest::MD5.hexdigest(string)
    md5.to_s
    return md5
  end

  acts_as_authentic do |c|
    c.validate_email_field = true
    c.require_password_confirmation = false
  end # block optional

  def uncategorized_skills
    self.user_skills.select { |us| us.discipline_id.nil? }.map { |us| us.skill }
  end

  def novice?
    res = self.resumes
    return res.size == 0 || DateTime.now.weeks_ago(2) < res.first.created_at
  end
end