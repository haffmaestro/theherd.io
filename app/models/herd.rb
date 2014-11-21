class Herd < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, uniqueness: true,length: {maximum: 25 }, subdomain_format: true

  has_many :users
end
