class TargetsController < ApplicationController
  before_filter :correct_user, only: [:destroy]

  def new
    @target = Target.new
  end

  def create
    @target = Target.new(params[:target])

    if @target.save
      flash[:success] = "Target was added!"
      redirect_to @target.goal
    else
      render "new"
    end
  end

  def show
    @target = Target.find(params[:id])
  end

  def destroy
    @target = Target.find(params[:id])
    @goal = @target.goal

    if @target.destroy
      flash[:success] = "Target was deleted"
      redirect_to @goal
    else
      render "show"
    end
  end

  private

    def correct_user
      @target = Target.find(params[:id])
      @user = User.find(@target.goal.user_id)
      redirect_to current_user, notice: "Access denied" unless current_user?(@user)
    end
end
