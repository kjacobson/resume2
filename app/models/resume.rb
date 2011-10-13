class Resume < ActiveRecord::Base
    belongs_to :user
    has_many :jobs
    has_many :softwares
end
