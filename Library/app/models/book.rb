class Book < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :author, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :record, :status, :title

  before_validation do |book|
    if book.new_record?
      if book.lent.blank? then book.lent = false end
      if book.record.blank? then book.record = nil end
      if book.status.blank? then book.status = 'model.book.status.to_buy' end
    end
  end

  validates_associated :user
  validates :author, :isbn, :isbn13, :status, :title, presence: true
  validates :isbn, length: { in: 9..10 }
  validates :isbn13, length: { is: 13 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validates :status, inclusion: { in: %w(model.book.status.to_buy model.book.status.to_read model.book.status.already_read) }

  def self.fetch_info(hash_books)
    books = []
    books << Book.new(
      author: hash_books.authors.author.name,
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
    return books
  end

  def self.search(isbn,title)
    # Start GoodReads API request
    client = Goodreads.new
    books = []
    if !isbn.blank?
      books = Book.fetch_info(client.book_by_isbn(isbn))
    elsif !title.blank?
      books = Book.fetch_info(client.book_by_title(title))  
    end
    return books
  end
end
