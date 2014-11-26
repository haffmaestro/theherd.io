class HerdsController < ApplicationController
  before_action :find_herd, only: [:show]
  before_action :authenticate_user!, only: [:show, :invite_friends, :edit]
  def index
  end

  def new
    @onboarding = true
    @herd = Herd.new
    render layout: 'onboarding'
  end

  def create
    @herd = Herd.new herd_params
    if @herd.save
      redirect_to new_user_registration_url(subdomain: @herd.subdomain)
    else
      render :new
    end
  end

  def show
    
    # if @herd.users.count == 1
    #   redirect_to invite_url(subdomain: herd_subdomain)
    # end

  end

  def invite_friends
    @herd = Herd.find_by_subdomain!(request.subdomain)  
  end

  private

  def herd_params
    params.require(:herd).permit(:name, :subdomain)
  end
end
