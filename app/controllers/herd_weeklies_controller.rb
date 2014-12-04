class HerdWeekliesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :invite_friends, :edit]
  
  def index
  end

  def show
  end
end
