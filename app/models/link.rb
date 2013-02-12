class Link < ActiveRecord::Base
  belongs_to :resume
  before_validation :assign_hash
  validates :hash, :uniqueness => true, :presence => true
  validates :resume_id, :presence => true
  require 'digest/md5'

  def url
    resume = self.resume
    if !resume.nil?
      user_id = resume.user.id
      host = AppConfig.config[:host]
      return "http://" + host + "/users/#{user_id}/resumes/#{resume.id}?access_key=" + self.hash
    else
      return ""
    end
  end

  def assign_hash
    self.hash = Link.generate_hash
    return true
  end

  def self.generate_hash
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
    string  =  (0..16).map{ o[rand(o.length)]  }.join;

    md5 = Digest::MD5.hexdigest(string)
    md5.to_s
    return md5
  end

  def expired?
    !self.expiration.nil? and self.expiration.past?
  end
end
