class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, request_keys: [:subdomain]

  belongs_to :herd
  has_many :user_weeklies, dependent: :destroy
  has_many :focus_areas, -> {order 'name ASC'}, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :goals, through: :focus_areas, dependent: :destroy
  mount_uploader :picture, PictureUploader
  delegate :url, to: :picture, prefix: true
  
  after_create :set_default_focus_areas, :send_welcome_email, :create_first_user_weekly

  
  def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email], :subdomain => warden_conditions[:subdomain]).first
  end

  def weekly_tasks
    tasks = []
    user_weeklies.each do |user_weekly|
      user_weekly.sections.each do |section|
        section.weekly_tasks.each do |task|
          tasks << task
        end
      end
    end
    tasks
  end

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^to_hash/
      self.attributes
    else
      super
    end
  end

  def respond_to?(meth)
    if meth.to_s =~ /^to_hash/
      true
    else
      super
    end
  end

  def has_todoist
    if self.todoist_api_token.blank?
      false
    else
      true
    end
  end

  private

  def set_default_focus_areas
    default = ["Physical", "Social", "Emotional", "Spiritual", "Professional", "Intellectual", "Financial"]
    default.each do |area|
      self.focus_areas.create(name: area)
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end

  def create_first_user_weekly
    create_user_weekly_service = Reports::CreateUserWeekly.new(user: self)
    user_weekly = create_user_weekly_service.call
    user_weekly.herd_weekly = self.herd.herd_weeklies.last
    user_weekly.save!
  end



end

