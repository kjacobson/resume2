class LoginValidation < ActiveRecord::Base
  belongs_to :user
  before_validation :assign_hash
  validates :unique_key, :uniqueness => true, :presence => true
  validates :user_id, :presence => true
  require 'digest/md5'

  def url
    user = self.user
    if !user.nil?
      host = AppConfig.config[:host]
      return "http://" + host + "/login?email=#{user.email}&validation_key=" + self.unique_key
    else
      return ""
    end
  end

  def assign_hash
    self.unique_key = LoginValidation.generate_hash
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
    !self.expiration_date.nil? and self.expiration_date.past?
  end
end
