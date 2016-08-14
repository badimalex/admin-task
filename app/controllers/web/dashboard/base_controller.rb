module Web
  module Dashboard
    class BaseController < ::BaseController
      before_action :authorize
    end
  end
end
