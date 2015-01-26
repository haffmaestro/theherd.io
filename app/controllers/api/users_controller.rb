class Api::UsersController < Api::BaseController

  def index
    @user = current_herd.users
    render json: @user, each_serializer: UserSerializer
  end
end