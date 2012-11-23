class ReviewCommentController < ApplicationController
 # rescue_from Exception, :with => :render_error_page
 # helper :diff

  # This method accepts the review_file from the view-form and calculates/creates
  # appropriate directories to store the file. The following two parameters need
  # to be passed in from the view:
  # params[:participant_id], params[:uploaded_review_file]

  def submit_comment
    @comment = ReviewComment.new
    @comment.review_file_id = params[:file_id]
    @comment.file_offset = params[:file_offset]
    @comment.comment_content = params[:comment_content].gsub("\n", " ")
    @comment.reviewer_participant_id = AssignmentParticipant.find_by_user_id(
        session[:user].id).id
    @comment.save
  end

  # Needs params[:file_id], params[:file_offset]
  def get_comment
    all_comment_contents = []
    ReviewComment.find_all_by_review_file_id_and_file_offset(
        params[:file_id], params[:file_offset]).each { |comment|
      all_comment_contents << comment.comment_content.gsub("\n", " ")
    }
    comments_in_table = ReviewCommentsHelper::construct_comments_table(
        all_comment_contents)

    respond_to do |format|
      format.js { render :json => comments_in_table }
    end
  end

  private

  def render_error_page(exception = nil)
    redirect_to :controller => 'content_pages', :action => 'show',
                :id => SystemSettings.find(:first).not_found_page_id

  end

end
