class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :registrations_controller?
  before_filter :find_herd, unless: :onboarding?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def onboarding?
    if self.class.name == "OnboardingController"
      true
    elsif self.class.name == "RegistrationsController"
      true
    elsif self.class.name.split("::").first == "Devise"
      true
    elsif @onboarding
      true
    elsif self.class.name == "HerdsController" && (params[:action] == "new" || params[:action]== "create")
      true
    end
  end

  def registrations_controller?
    if self.class.name == "RegistrationsController"
      true
    else
      false
    end
  end

  def self_class
    self.class.name
  end
  
  def current_herd
    Herd.find_by_subdomain!(request.subdomain)
  end

  def herd_subdomain
    @herd.subdomain
  end

  def find_herd
    @herd = current_herd
    current_herd 
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name,  :last_name) } 
  end
  helper_method :herd_subdomain
  helper_method :onboarding?
  helper_method :self_class
  helper_method :current_herd

end

