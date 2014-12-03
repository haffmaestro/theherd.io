class Api::CommentsController < Api::BaseController

	def index
		section = Section.find params[:section_id]
		render json: section.comments
	end

	def create
	end

	def destroy
	end
end