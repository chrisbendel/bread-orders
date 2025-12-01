class Storefront::SubscriptionsController < ApplicationController
  before_action :require_authentication!
  before_action :set_store

  def create
    @subscription = current_user.store_subscriptions.find_or_create_by(store: @store)
    redirect_to storefront_path(@store.slug), notice: "You’re now following this store."
  end

  def destroy
    current_user.store_subscriptions.where(store: @store).destroy_all
    redirect_to storefront_path(@store.slug), notice: "You’re no longer following this store."
  end

  private

  def set_store
    @store = Store.find_by!(slug: params[:slug])
  end
end
