class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = User.find(params[:id])
    @book = @user.books
    @books = @user.books
    @book_new = Book.new

    @books = @user.books.page(params[:page]).reverse_order
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @days2_book = @books.created_2days
    @days3_book = @books.created_3days
    @days4_book = @books.created_4days
    @days5_book = @books.created_5days
    @days6_book = @books.created_6days
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
    @user = User.find(current_user.id)


  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  def followeds
    user = User.find(params[:user_id])
    @users = user.followeds
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
