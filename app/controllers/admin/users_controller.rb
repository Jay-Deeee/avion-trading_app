class Admin::UsersController < ApplicationController
  before_action :require_admin!
  before_action :set_user_id, only: %i[edit update edit_password update_password]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    set_given_password
    bypass_approval_and_confirmation

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

  def pending
    @pending_users = User.where(approved: false)
  end

  def approve
    user = User.find(params[:id])
    user.update(approved: true)
    user.send_confirmation_instructions unless user.confirmed?
  
    redirect_to admin_users_path, notice: "User approved and confirmation email sent."
  end

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

  def set_given_password
    @user.password = "password"
    @user.password_confirmation = "password"
  end

  def bypass_approval_and_confirmation
    @user.approved = true
    @user.confirmed_at = Time.current
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def record_not_found
    redirect_to admin_root_path, alert: "Record does not exist."
  end
end
