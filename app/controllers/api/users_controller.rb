class Api::UsersController < Api::BaseController

  def index
    @user = current_user
    @users = current_herd.users
    render json: @users, each_serializer: UserSerializer, scope: self
  end
end