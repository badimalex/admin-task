module Web
  module Dashboard
    class TasksController < BaseController
      skip_before_action :authorize, only: [:index]

      def index
      end
    end
  end
end
