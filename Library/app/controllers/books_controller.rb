class BooksController < ApplicationController
  def create
    @book = Book.new(params[:book].merge({ :user_id => current_user.id }))
    @book.save
    redirect_to books_url
  end
  def edit
    @book = Book.find(params[:id])
  end
  def get
    @book = Book.find(params[:id])
  end
  def index
    @books = current_user.book
  end
  def new
  end
  def search
    @books = Book.search(params[:book][:isbn], params[:book][:title])
  end
end
