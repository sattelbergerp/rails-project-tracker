class ProjectsController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_project, only: [:show]

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

  def set_project
    @project = current_user.projects.find_by(id: params[:id], user: current_user)
    render status: :not_found, text: 'That project does not exist or was created by a different user.' if !@project
  end

end
