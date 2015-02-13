module Api
	class SectionsController < Api::BaseController
		def update
			# render json: params
			section = Section.find params[:section_id]
			if section.update section_params
				if UserWeekly.is_done?(section.user_weekly)
					section.user_weekly.create_activity key: 'user_weekly.complete', owner: current_user, herd_id: current_herd.id
				end
				render json: {updated: true}
			else
				render json: {updated: false}
			end
		end


		def section_params
			params.require(:section).permit(:id, :body, :name)
		end
	end
end