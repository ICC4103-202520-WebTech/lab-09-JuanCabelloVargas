class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  load_and_authorize_resource except: :index

  def index
    if user_signed_in? && params[:mine].present?
      @recipes = current_user.recipes.order(created_at: :desc)
      flash.now[:alert] = "You don't have recipes." if @recipes.empty?
    else
      @recipes = Recipe.accessible_by(current_ability).order(created_at: :desc)
    end
  end

  def show
  end

  def new
  end

  def create
    @recipe.user ||= current_user

    if @recipe.save
      redirect_to @recipe, notice: "Recipe created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted."
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :content, :difficulty, :cook_time)
  end
end
