class Web::Dashboard::TasksController < Web::Dashboard::BaseController
  skip_before_action :authorize, only: [:index, :show]
  before_action :load_task, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @task.attachments.build
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task
    else
      redirect_to edit_task_path(@task)
    end
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

  def destroy
    @task.destroy
    redirect_to my_tasks_path, flash: { notice: t('task.removed') }
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, attachments_attributes: [:file])
  end

  def load_task
    @task = Task.find(params[:id])
  end

  def check_owner
    redirect_to root_path, flash: {alert: t('errors.non_owner') } unless current_user.author_of?(@task)
  end
end
