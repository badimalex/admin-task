class Web::Dashboard::TasksController < Web::Dashboard::BaseController
  skip_before_action :authorize, only: [:index]

  def index
  end

  def new
    @task = Task.new
  end

  def show
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, flash: {success: t('task.created')}
    else
      render :new
    end
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
