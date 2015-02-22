module Api
	class CommentsController < BaseController

		def index
			section = Section.find params[:section_id]
			render json: section.comments
		end

		def create
		comment = Comment.new comment_params
			if comment.save
				comment_create_activity(comment)
				render json: comment, serializer: CommentSerializer
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

		def comment_create_activity(comment)
			comment.create_activity :create, owner: current_user, recipient: comment.section.user_weekly.user, herd_id: current_herd.id
		end
	end
end