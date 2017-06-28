class TasksController < ApplicationController

  before_action :ensure_logged_in

  def index
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to task_path(@task)
    else
      render "new"
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :complete_by, :completed, project_ids: [])
  end

end
