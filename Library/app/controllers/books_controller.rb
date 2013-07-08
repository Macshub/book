class BooksController < ApplicationController
  def index
    @books = Book.all
  end
  def new
  end
  def search
    url = Nokogiri::XML(open("http://www.goodreads.com/book/isbn?isbn="+params[:book][:isbn]+"&key=mGuETvHmUq2AJGNpuyPhDw&format=xml")).xpath("//book").first

    @hash_book = {
      isbn: url.xpath("isbn").text,
      isbn13: url.xpath("isbn13").text,
      title: url.xpath("title").text,
      image_url: url.xpath("image_url").text,
      publication_year: url.xpath("publication_year").text,
      publication_month: url.xpath("publication_month").text,
      publication_day: url.xpath("publication_day").text,
      original_publication_day: url.xpath("work/original_publication_day").text,
      original_publication_month: url.xpath("work/original_publication_month").text,
      original_publication_year: url.xpath("work/original_publication_year").text,
      publisher: url.xpath("publisher").text,
      description: url.xpath("description").text,
      author_name: url.xpath("authors/author/name").text,
      average_rating: url.xpath("average_rating").text,
      num_pages: url.xpath("num_pages").text
    }
  end
end
