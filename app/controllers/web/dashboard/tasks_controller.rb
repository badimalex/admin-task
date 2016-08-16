class Web::Dashboard::TasksController < Web::Dashboard::BaseController
  skip_before_action :authorize, only: [:index, :show]
  before_action :load_task, only: [:show, :edit, :update, :destroy]

  authorize_resource

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
  end

  def create
    @task = current_user.admin? ? Task.new(task_params) : current_user.tasks.new(task_params)
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
    params.require(:task).permit(:user_id, :name, :description, attachments_attributes: [:file])
  end

  def load_task
    @task = Task.find(params[:id])
  end
end
