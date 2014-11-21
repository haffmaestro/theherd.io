class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def onboarding?
    if self.class.name == "OnboardingController"
      true
    elsif self.class.name == "RegistrationsController"
      true
    elsif @onboarding
      true
    end
  end

  def self_class
    self.class.name
  end
  
  helper_method :onboarding?
  helper_method :self_class
  def current_herd
    Herd.find_by_subdomain!(request.subdomain)
  end

  def herdo
    "Herdo"
  end

  def herd_subdomain
    @herd.subdomain
  end

  def find_herd
    @herd = current_herd 
  end

end
