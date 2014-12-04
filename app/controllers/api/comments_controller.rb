class Api::CommentsController < Api::BaseController

	def index
		section = Section.find params[:section_id]
		render json: section.comments
	end

	def create
		# render json: params
		comment = Comment.new comment_params
		if comment.save
			render json: {saved: true}
		else
			render json: {saved: false}
		end

	end

	def destroy
	end

	private
	def comment_params
		params.require(:comment).permit(:body, :user_id, :section_id)
	end
end