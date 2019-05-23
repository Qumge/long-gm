class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :my_notices

  def my_notices
    if current_user.present?
      @unread_notices = current_user.unread_notices
      @unreply_notices = current_user.unreply_notices
    end
  end

end
