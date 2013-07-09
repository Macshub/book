class BooksController < ApplicationController
  before_filter :belongs_to_user, only: [ :destroy, :edit, :update, :show ]
  before_filter :user_signed_in
  def belongs_to_user
    unless current_user.book.map(&:id).include? params[:id]
      redirect_to books_url
    end
  end
  def user_signed_in
    unless user_signed_in?
      redirect_to new_user_session_url
    end
  end
  def create
    @book = Book.new(params[:book].merge({ user_id: current_user.id }))
    @book.save
    render show
  end
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url
  end
  def edit
    @book = Book.find(params[:id])
  end
  def index
    @books = current_user.book
  end
  def new
  end
  def update
    @book = Book.find(params[:id])
    @book.update_attributes(params[:book])
    render show
  end
  def search
    @books = Book.search(params[:book][:isbn], params[:book][:title])
  end
  def show
    @book = Book.find(params[:id])
  end
end
