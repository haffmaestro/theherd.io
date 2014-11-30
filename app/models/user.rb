class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, request_keys: [:subdomain]

  belongs_to :herd
  has_many :user_weeklies
  has_many :focus_areas
  has_many :comments
  has_many :goals, through: :focus_areas

  after_create :set_default_focus_areas
  
  def self.find_for_authentication(warden_conditions)
      where(:email => warden_conditions[:email], :subdomain => warden_conditions[:subdomain]).first
  end

  private

  def set_default_focus_areas
    default = ["Physical", "Social", "Emotional", "Spiritual", "Professional", "Intellectual", "Financial"]
    default.each do |area|
      self.focus_areas.create(name: area)
    end
  end

end

