class GoalsController < ApplicationController
  def new
    @goal = current_user.goals.new
  end

  def create
    @goal = current_user.goals.new(params[:goal])

    if @goal.save
      flash[:success] = "Goal was added!"
      redirect_to current_user
    else
      render "new"
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def destroy
    @goal = Goal.find(params[:id])
    
    if @goal.destroy
      flash[:success] = "Goal was deleted"
      redirect_to current_user
    else
      render "show"
    end
  end
end
