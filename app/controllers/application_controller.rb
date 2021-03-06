class ApplicationController < ActionController::Base
  helper_method :current_user

  before_action :require_login
  before_action :set_sidebar_databases, :set_search_result, only: %w(index show new edit)

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    return if current_user
    redirect_to sign_in_path(return_to: url_for(params.to_unsafe_h.merge(only_path: true)))
  end

  def require_admin_login
    redirect_to root_path unless current_user.admin?
  end

  def set_sidebar_databases
    @sidebar_databases = DatabaseMemo.all.select(:name).order(:name)
  end

  def set_search_result
    @search_result = SearchResult.new
  end
end
