class Api::SectionsController < Api::BaseController
	def update
		render json: params
	end
end