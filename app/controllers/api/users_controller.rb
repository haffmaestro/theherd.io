class Api::UsersController < Api::BaseController

  def index
    @users = current_herd.users
    render json: @users, each_serializer: UserSerializer
  end
end