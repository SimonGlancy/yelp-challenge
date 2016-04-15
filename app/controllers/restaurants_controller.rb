class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
    if current_user.id != Restaurant.find(params[:id]).user_id
      flash[:notice] = 'You cannot edit this restaurant'
      redirect_to '/restaurants'
    else
      @restaurant = Restaurant.find(params[:id])
    end
  end

  def update
    if current_user.id != Restaurant.find(params[:id]).user_id
      flash[:notice] = 'You cannot edit this restaurant'
    else
      @restaurant = Restaurant.find(params[:id])
      @restaurant.update(restaurant_params)
      redirect_to '/restaurants'
    end
  end

  def destroy
    if current_user.id != Restaurant.find(params[:id]).user_id
      flash[:notice] = 'You cannot delete this restaurant'
      redirect_to '/restaurants'
    else
      @restaurant = Restaurant.find(params[:id])
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted sucessfully'
      redirect_to '/restaurants'
    end
  end


end
