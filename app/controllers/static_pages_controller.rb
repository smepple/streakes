class StaticPagesController < ApplicationController
  def home
    redirect_to current_user if signed_in?
  end
end
