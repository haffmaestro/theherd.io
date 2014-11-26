class OnboardingController < ApplicationController
  
  def index
    if current_user
      redirect_to weekly_url(current_user.herd.herd_weeklies.last, subdomain: current_user.herd.subdomain)
    else
      @welcomepage = true
      render layout: "onboarding"
    end
  end
end
