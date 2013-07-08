class BookController < ApplicationController
  def index
    @books = Book.all
  end
  def new
  end
end
