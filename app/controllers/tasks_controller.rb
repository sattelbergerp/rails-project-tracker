class TasksController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  #Check to see if we are in a nested url and set the project if we are
  before_action :set_project, only: [:edit, :update, :destroy, :create]

  def index
    case params[:filter]
    when "overdue"
      @tasks = current_user.tasks.overdue
    when "completed"
      @tasks = current_user.tasks.completed
    when "not_completed"
      @tasks = current_user.tasks.not_completed
    when "due_today"
      @tasks = current_user.tasks.due_today
    else
        @tasks = current_user.tasks
    end

    respond_to do |format|
      format.html
      format.json { render :json => @tasks }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => @task }
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    #rails includes a blank project_id for some reason
    if (@project || params[:task][:project_ids].count > 1) && @task.save
      @task.add_project(@project)
      @project ? render(json: @task) : redirect_to(task_path(@task))
    else
      @task.errors[:projects] << 'must contain at least one project' if params[:task][:project_ids] && params[:task][:project_ids].count < 2
      @project ? redirect_to(project_path(@project)) : render("new")
    end
  end

  def update
    #raise params.inspect
    #rails includes a blank project_id for some reason
    if params[:task][:project_ids].count > 1 && @task.update(task_params)
      @project_task.update(project_task_params) if @project && @project_task
      @project ? redirect_to(project_path(@project)) : redirect_to(task_path(@task))
    else
      @task.errors[:projects] << 'must contain at least one project' unless params[:task][:project_ids].count > 1
      render "edit"
    end
  end

  def destroy
    if !@project || @task.projects.count < 2
      @task.delete
    else
      @project.tasks.delete(@task)
    end
    @project ? redirect_to(project_path(@project)) : redirect_to(tasks_path)
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :complete_by, :completed, project_ids: [])
  end

  def project_task_params
    params.require(:project_task).permit(:priority)
  end

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    render status: :not_found, text: 'The requested task does not exist or was created by a different user.' if !@task
  end

  def set_project
    #Simply behave as if the project is not there if for some reason we can't find it
    #this should never happen and should not matter if it does
    @project = current_user.projects.find_by(id: params[:project_id])
    @project_task = @project.project_tasks.find_by(task_id: @task.id) if @task && @project
  end

end
