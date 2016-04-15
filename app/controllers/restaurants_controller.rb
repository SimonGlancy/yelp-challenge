class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def create
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @current_user = User.find(session[:user_id])
    @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        redirect_to restaurants_path
        # append to current user that's signed in
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
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    flash[:notice] = 'Restaurant deleted sucessfully'
    redirect_to '/restaurants'
  end


end
