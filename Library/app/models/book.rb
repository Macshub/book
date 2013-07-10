class Book < ActiveRecord::Base
  belongs_to :user
  attr_accessible :author_name, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :record, :status, :title

  before_create do |book|
    book.lent ||= false
    book.record ||= nil
    book.status ||= 'model.book.status.to_buy'
  end

  validates_associated :user
  validates :author_name, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :status, :title, presence: true, allow_nil: true
  validates :isbn, length: { is: 9 }, allow_nil: true
  validates :isbn13, length: { is: 13 }, allow_nil: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validates :status, inclusion: { in: %w('model.book.status.to_buy', 'model.book.status.to_read', 'model.book.status.already_read') }


  def self.fetch_info(hash_books)
    books =[]
    books << Book.new(
      author_name: hash_books.authors.author.name,
      cover: hash_books.image_url,
      description: hash_books.description,
      isbn: hash_books.isbn,
      isbn13: hash_books.isbn13,
      original_publication: Date.parse(hash_books.work.original_publication_year.to_s + '-01-01'),
      pages: hash_books.num_pages,
      publication: Date.parse(hash_books.work.publication_year.to_s + '-01-01'),
      publisher: hash_books.publisher,
      rating: hash_books.average_rating,
      title: hash_books.title
    )
    books
  end

  def self.search(isbn,title)
    # Start GoodReads API request

    client = Goodreads.new
    books = []
    if !isbn.blank?
      books = Book.fetch_info(client.book_by_isbn(isbn))
      p books.size
    elsif !title.blank?
      books = Book.fetch_info(client.book_by_title(title))  
    end
    books
  end

end
