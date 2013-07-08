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
    # Start GoodReads API request
    url = Nokogiri::XML(open("http://www.goodreads.com/book/isbn?isbn="+params[:book][:isbn]+"&key=mGuETvHmUq2AJGNpuyPhDw&format=xml")).xpath("//book").first

    if url.xpath("publication_year").text == '' || url.xpath("publication_month").text == '' || url.xpath("publication_day").text == ''
      publication = nil
    else
      publication = Date.parse(url.xpath("publication_year").text + '-' + url.xpath("publication_month").text + '-' + url.xpath("publication_day").text)
    end
    if url.xpath("original_publication_year").text == '' || url.xpath("original_publication_month").text == '' || url.xpath("original_publication_day").text == ''
      original_publication = nil
    else
      original_publication = Date.parse(url.xpath("original_publication_year").text + '-' + url.xpath("original_publication_month").text + '-' + url.xpath("original_publication_day").text)
    end
    api_result = {
      author_name: url.xpath("authors/author/name").text,
      cover: url.xpath("image_url").text,
      description: url.xpath("description").text,
      isbn: url.xpath("isbn").text,
      isbn13: url.xpath("isbn13").text,
      original_publication: original_publication,
      pages: url.xpath("num_pages").text,
      publication: publication,
      publisher: url.xpath("publisher").text,
      rating: url.xpath("average_rating").text,
      title: url.xpath("title").text
    }
    # End GoodReads API request

    book_hash = api_result
    @book = Book.new(
      author_name: book_hash[:author_name],
      cover: book_hash[:cover],
      description: book_hash[:description],
      isbn: book_hash[:isbn],
      isbn13: book_hash[:isbn13],
      original_publication: book_hash[:original_publication],
      pages: book_hash[:pages],
      publication: book_hash[:publication],
      publisher: book_hash[:publisher],
      rating: book_hash[:rating],
      title: book_hash[:title]
    )
  end
end
