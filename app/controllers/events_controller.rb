class EventsController < ApplicationController
  before_filter :correct_user, only: [:destroy]
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      flash[:success] = "Event was saved!"
      redirect_to @event.target
    else
      render "new"
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @target = @event.target

    if @event.destroy
      flash[:success] = "Event was deleted"
      redirect_to @target
    else
      render "show"
    end
  end

  private

    def correct_user
      @event = Event.find(params[:id])
      @user = User.find(@event.target.goal.user_id)
      redirect_to current_user, notice: "Access denied" unless current_user?(@user)
    end
end
