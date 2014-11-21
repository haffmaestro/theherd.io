class OnboardingController < ApplicationController
  def index
    if current_user
      redirect_to herd_url(subdomain: current_user.herd.subdomain)
    else
      @welcomepage = true
      render layout: "onboarding"
    end
  end
end
