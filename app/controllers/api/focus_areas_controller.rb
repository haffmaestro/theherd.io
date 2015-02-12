module Api
  class FocusAreasController < Api::BaseController
    def index
      render json: current_user.focus_areas, each_serializer: SimpleFocusAreaSerializer
    end

    def create
      focus_area = FocusArea.new focus_area_params
      focus_area.user = current_user
      if focus_area.save
        focus_area = focus_area.attributes.merge({is_owner: true})
        render json: {saved: true, focus_area: focus_area}
      else
        render json: {saved: false, focus_area: focus_area}
      end
    end

    def update
      focus_area = FocusArea.find(params[:id])
      if focus_area.update(focus_area_params)
        focus_area = focus_area.attributes.merge({is_owner: true})
        render json: {updated: true, focus_area: focus_area}
      else
        render json: {updated: false, focus_area: focus_area}
      end
    end


    def destroy
      focus_area = FocusArea.find(params[:id])
      if focus_area.destroy
        render json: {destroyed: true, focus_area: focus_area}
      else
        render json: {destroyed: true}
      end
    end

    private
    def focus_area_params
      params.require(:focus_area).permit(:name, :user_id)
    end
  end
end