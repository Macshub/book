class BooksController < ApplicationController
  def index
    @books = Book.all
  end
  def new
  end
  def search
    isbn = params[:book][:isbn]
    @book = Book.new
    @book.isbn = '123456789'
  end
end
