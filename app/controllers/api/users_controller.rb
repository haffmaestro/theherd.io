module Api
  class UsersController < Api::BaseController

    def index
      @user = current_user
      @users = current_herd.users
      render json: @users, each_serializer: UserSerializer, scope: self
    end

    def login_todoist
      user = User.find(params[:id])
      response = Todoist.login(params[:todoist_email], params[:todoist_password])
      if response == "WRONG_PASSWORD_OR_EMAIL"
        render json: {msg: "WRONG_PASSWORD_OR_EMAIL", success: false}
      elsif response.has_key?("email")
        user.todoist_api_token = response["api_token"]
        if user.save
          render json: {msg: "Todoist Integration Added", success: true}
        else
          render json: {msg: "Error at theHerd server", success: false}
        end
      else
        render json: {msg: "Error at Todoist server", success: false}
      end
    end

  end
end