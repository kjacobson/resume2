class User < ActiveRecord::Base
  has_many :cvs

  has_many :jobs
  has_many :skills
  has_many :softwares
  has_many :highlights

  acts_as_authentic do |c|
    c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional
end