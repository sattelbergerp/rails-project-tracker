class TasksController < ApplicationController

  before_action :ensure_logged_in

  def index
    @tasks = current_user.tasks
  end

end
