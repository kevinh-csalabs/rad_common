class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    skip_authorization

    if user_signed_in?
      redirect_to RadicalConfig.start_route!
    else
      redirect_to new_user_session_path
    end
  end
end
