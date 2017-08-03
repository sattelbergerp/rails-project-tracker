class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    '/projects'
  end

  def after_sign_up_path_for(resource)
    '/projects'
  end

  def ensure_logged_in
    render status: :forbidden, text: "You don't have permission to access that. If you are trying to access a project you created try logging in." if !current_user
  end

  before_action :fakelag
  def fakelag
    sleep 1.0
  end
end
