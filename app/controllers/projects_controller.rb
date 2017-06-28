class ProjectsController < ApplicationController

  before_action :ensure_logged_in

  def index
    @projects = current_user.projects
  end

end
