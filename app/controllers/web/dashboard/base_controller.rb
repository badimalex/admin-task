module Web
  module Dashboard
    class BaseController < Web::BaseController
      before_action :authorize
    end
  end
end
