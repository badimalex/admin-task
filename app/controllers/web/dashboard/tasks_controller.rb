class Web::Dashboard::TasksController < Web::Dashboard::BaseController
  skip_before_action :authorize, only: [:index, :show]
  before_action :load_task, only: [:show]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @task.attachments.build
  end

  def show
    puts @task.attachments.inspect
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, flash: {success: t('task.created')}
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, attachments_attributes: [:file])
  end

  def load_task
    @task = Task.find(params[:id])
  end
end
