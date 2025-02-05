class CookiesController < ApplicationController
  def accept
    cookies[:analytics] = {
      :value => 'accepted',
      :expires => 1.year.from_now
    }
    redirect_to root_path
  end

  def reject
    cookies[:analytics] = {
      :value => 'rejected',
      :expires => 1.year.from_now
    }
    redirect_to root_path
  end
end
