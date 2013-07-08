class BooksController < ApplicationController
  def index
    @books = Book.all
  end
  def new
  end
  def search
    @book = Book.new
  end
end
