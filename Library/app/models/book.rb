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

  paginates_per 3

  def self.fetch_info(hash_books)
    books = []
    book = Book.new(
      author: hash_books.authors.author.name,
      cover: hash_books.image_url,
      description: hash_books.description,
      isbn: hash_books.isbn,
      isbn13: hash_books.isbn13,
      pages: hash_books.num_pages,
      publication: Date.parse(hash_books.work.publication_year.to_s + '-01-01'),
      publisher: hash_books.publisher,
      rating: hash_books.average_rating,
      title: hash_books.title
    )
    if hash_books.work.original_publication_year > 0
      book.original_publication = Date.parse(hash_books.work.original_publication_year.to_s + '-01-01')
    else
      book.original_publication = Date.new(0003-01-01)
    end
    books << book
    return books
  end

  def self.search(isbn, options = {})
    # Start GoodReads API request
    client = Goodreads.new
    books = []
    books_found = []
    books_not_found = []
    if !isbn.blank?
      if isbn.is_a?(Array)
        isbn.each do |isbn_single|
          begin
            books << Book.fetch_info(client.book_by_isbn(isbn_single))
            books_found << isbn_single
            p isbn_single + ' => ok'
          rescue
            books_not_found << isbn_single
            p isbn_single + ' => ko'
          end
        end
        books = books.flatten
      else
        books = Book.fetch_info(client.book_by_isbn(isbn))
      end
    elsif !options[:title].blank?
      books = Book.fetch_info(client.book_by_title(options[:title]))  
    end
    if options[:user_id]
      books.each do |book|
        book.user_id = options[:user_id]
      end
    end
    if options[:save_search]
      books.each do |book|
        book.save
      end
    end
    result = { ok: [ books_found.size, books_found ], ko: [ books_not_found.size, books_not_found ] }
    p result.inspect
    return books
  end
end
