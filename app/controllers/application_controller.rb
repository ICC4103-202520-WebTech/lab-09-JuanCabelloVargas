class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "You dont have permission to do that"
  end
end
