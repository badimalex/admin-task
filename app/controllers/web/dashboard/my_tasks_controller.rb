class Web::Dashboard::MyTasksController < Web::Dashboard::BaseController
  def index
    @tasks = current_user.tasks
  end
end
