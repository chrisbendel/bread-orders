class Stores::EventsController < ApplicationController
  before_action :require_authentication!
  before_action :set_store
  before_action :set_event, only: [:show, :edit, :update, :destroy, :publish, :duplicate]

  def index
    @events = @store.events.order(pickup_at: :asc)
  end

  def show
    @orders = @event.orders.includes(user: [], order_items: [:event_product]).order(created_at: :asc)
  end

  def new
    @event = @store.events.new
  end

  def create
    @event = @store.events.new(event_params)

    if @event.save
      redirect_to event_path(@event), notice: "Event created (Draft)."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def duplicate
    new_event = @event.dup
    new_event.name = "Copy of #{new_event.name}"
    new_event.published_at = nil
    new_event.pickup_at = @event.pickup_at + 1.week if @event.pickup_at
    new_event.orders_close_at = @event.orders_close_at + 1.week if @event.orders_close_at

    if new_event.save(validate: false)
      @event.event_products.each do |ep|
        new_ep = ep.dup
        new_ep.event = new_event
        if ep.image.attached?
          new_ep.image.attach(ep.image.blob)
        end
        new_ep.save!
      end
      redirect_to edit_event_path(new_event), notice: "Event duplicated. Please update your dates."
    else
      redirect_to store_events_path, alert: "Could not duplicate event."
    end
  end

  def publish
    @event.publish!

    @store.notifications.includes(:user).find_each do |notification|
      StoreMailer.new_event(@store, @event, notification).deliver_later
    end

    redirect_to event_path(@event), notice: "Event published and notifications sent!"
  rescue ActiveRecord::RecordInvalid
    redirect_to event_path(@event), alert: @event.errors.full_messages.to_sentence
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: "Event updated."
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
      :orders_close_at,
      :pickup_at
    )
  end
end
