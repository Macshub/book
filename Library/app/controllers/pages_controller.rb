class PagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to book_index_url
    else
      redirect_to new_user_session_url
    end
  end
end
