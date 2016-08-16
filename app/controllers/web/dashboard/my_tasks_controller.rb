class Web::Dashboard::MyTasksController < Web::Dashboard::BaseController
  def index
    @tasks = current_user.admin? ? Task.latest : current_user.tasks.latest
  end
end
