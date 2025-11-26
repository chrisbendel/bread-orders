class Stores::EventsController < ApplicationController
  before_action :require_authentication!
  before_action :set_store
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = @store.events.order(orders_open_at: :asc)
  end

  def show; end

  def new
    @event = @store.events.new
  end

  def create
    @event = @store.events.new(event_params)
    if @event.save
      redirect_to store_event_path(@event), notice: "Event created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to store_event_path(@event), notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to store_events_path, notice: "Event deleted."
  end

  private

  def set_store
    @store = current_user.store
  end

  def set_event
    @event = @store.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name,
      :description,
      :orders_open_at,
      :orders_close_at,
      :pickup_at
    )
  end
end
