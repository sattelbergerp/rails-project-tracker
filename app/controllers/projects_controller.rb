class ProjectsController < ApplicationController

  before_action :ensure_logged_in

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :description)
  end

end
