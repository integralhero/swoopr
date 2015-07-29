class EventsController < ApplicationController
  def new
  	@event = Event.new
  end

  def index
  	@events = Event.all
  end

  def create
  	@e = Event.new
    @e.location = event_params[:location]
    @e.name = event_params[:name]
    @e.owner_id = current_user.id
    @e.time = event_params[:time]
    @e.save
		redirect_to event_path(@e)
  end

  def edit
  	
  end

  def show
  	@event = Event.find(params[:id])
  end

  private
  	def event_params
  		params.require(:event).permit(:location, :time, :name)
  	end
end
