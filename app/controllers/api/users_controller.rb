module Api
  class UsersController < Api::BaseController

    def index
      @user = current_user
      @users = current_herd.users
      render json: @users, each_serializer: UserSerializer, scope: self
    end

    def login_todoist
    end

  end
end