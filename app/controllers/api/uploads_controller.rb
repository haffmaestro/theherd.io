module Api
  class UploadsController < BaseController
    
    def profile
      user = current_user
      user.picture = params[:file]
      if user.save
        render json: user, serializer: UserSerializer, scope: self
      else
        render json: {msg: "Error at theHerd server.", success: false}
      end
    end 
  end
end