class ProjectsController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
    @project.messages.build
  end

  def edit
    @project.messages.build
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project.tasks.each do |task|
      task.delete if task.projects.count < 2
    end
    @project.delete
    redirect_to projects_path
  end

  private
  def project_params
    params.require(:project).permit(:name, :description, messages_attributes: [:message_type, :content, :id])
  end

  def set_project
    @project = current_user.projects.find_by(id: params[:id], user: current_user)
    render status: :not_found, text: 'The requested project does not exist or was created by a different user.' if !@project
  end

end
