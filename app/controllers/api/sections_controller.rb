class Api::SectionsController < Api::BaseController
	def update
		# render json: params
		section = Section.find params[:section_id]
		if section.update section_params
			UserWeekly.is_done?(section.user_weekly)
			render json: {updated: true}
		else
			render json: {updated: false}
		end
	end


	def section_params
		params.require(:section).permit(:id, :body, :name)
	end
end