class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item
  end

  def create
    # item = Item.create(name: params[:name], description: params[:description], price: params[:price], user_id: params[:user_id])
    if params[:user_id]
      item = Item.create(nested_item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def nested_item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response
    render json: "404 Not Found", status: :not_found 
  end

end
