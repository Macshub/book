class BooksController < ApplicationController
  def create
    # TODO :: Fill this action
  end
  def index
    @books = Book.all
  end
  def new
  end
  def search
    @books = Book.search(params[:book][:isbn], params[:book][:title])
    puts @books
  end
end
