class TasksController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    #rails includes a blank project_id for some reason
    if params[:task][:project_ids].count > 1 && @task.save
      redirect_to task_path(@task)
    else
      @task.errors[:projects] << 'must contain at least one project' unless params[:task][:project_ids].count > 1
      render "new"
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :complete_by, :completed, project_ids: [])
  end

  def set_task
    @task = current_user.tasks.find_by(id: params[:id], user: current_user)
    render status: :not_found, text: 'The requested task does not exist or was created by a different user.' if !@task
  end

end
