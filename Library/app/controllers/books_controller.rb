class BooksController < ApplicationController
  before_filter :user_signed_in
  before_filter :belongs_to_user, only: [ :destroy, :edit, :update, :show ]
  def user_signed_in
    unless user_signed_in?
      redirect_to new_user_session_url
    end
  end
  def belongs_to_user
    unless current_user.books.map(&:id).include? params[:id].to_i
      redirect_to books_url
    end
  end
  def create
    @book = Book.new(params[:book].merge({ user_id: current_user.id }))
    @book.save
    redirect_to book_url(@book.id)
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
    @books = current_user.books
  end
  def new
  end
  def update
    @book = Book.find(params[:id])
    @book.update_attributes(params[:book])
    redirect_to book_url
  end
  def search
    @books = Book.search(params[:book][:isbn], { title: params[:book][:title] })
    unless @books.map{|book| book[:message]}.include? 'ok'
      redirect_to new_book_url(message: @books.first[:message])
    end
  end
  def show
    @book = Book.find(params[:id])
  end
end
