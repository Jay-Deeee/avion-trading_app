class Admin::UsersController < ApplicationController
  before_action :require_admin!
  before_action :set_user_id, only: %i[edit update edit_password update_password]
  # before_action :set_portfolio
  # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @users = User.order(first_name: :asc)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = "password"
    @user.password_confirmation = "password"

    if @user.save
      redirect_to admin_user_path(@user),notice: "New trader created."
    else
      flash.alert = 'Failed to create trader.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
			redirect_to admin_user_path(@user), notice: 'User has been updated'
    else
      flash.alert = 'Failed to update credentials.'
			render :edit, status: :unprocessable_entity
    end
  end

  def edit_password; end
  
  def update_password
    if @user.update(password_params)
      redirect_to admin_user_path(@user), notice: 'Password was successfully updated.'
    else
      flash.alert = 'Failed to change password.'
      render :edit_password, status: :unprocessable_entity
    end
  end
  
  # def destroy
  #   @portfolio.destroy
  #   redirect_to root_path, status: :see_other, notice: "Entry has been deleted."
  # end

  private

  def require_admin!
    redirect_to root_path, alert: "Restricted. Admin Access Only." unless current_user&.is_admin?
  end

  def set_user_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :balance)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # def record_not_found
  #   redirect_to categories_path, alert: "Record does not exist."
  # end

  # def invalid_foreign_key
  #   redirect_to categories_path, alert: "Unable to delete category. Still referenced from tasks."
  # end
end
