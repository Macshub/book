class Book < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :author, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :record, :status, :title

  paginates_per 10

  before_validation do |book|
    if book.new_record?
      if book.lent.blank? then book.lent = false end
      if book.record.blank? then book.record = nil end
      if book.status.blank? then book.status = 'model.book.status.to_buy' end
    end
  end
  # Filter preventing book duplication, not working
  # before_create do |book|
  #   if User.find(book.user_id).has_already_book?(book.isbn, book.isbn13)
  #     errors.add(exists: I18n.t('form.has_already_book'))
  #   end
  # end

  validates_associated :user
  validates :author, :isbn, :isbn13, :status, :title, presence: true
  validates :isbn13, length: { is: 13 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validates :status, inclusion: { in: %w(model.book.status.to_buy model.book.status.to_read model.book.status.already_read) }

  def self.fetch_info(response)
    if response.is_a?(Array)
      books = []
      response.results.work.each do |result|
        book = Book.new(
          author: result.authors.author.name,
          cover: result.image_url,
          description: result.description,
          isbn: result.isbn,
          isbn13: result.isbn13,
          pages: result.num_pages,
          publication: Date.parse(result.work.publication_year.to_s + '-01-01'),
          publisher: result.publisher,
          rating: result.average_rating,
          title: result.title
        )
        unless result.work.original_publication_year.nil?
          if result.work.original_publication_year > 0
            book.original_publication = Date.parse(result.work.original_publication_year.to_s + '-01-01')
          else
            book.original_publication = Date.new(0003-01-01)
          end
        else
          book.original_publication = Date.new(0003-01-01)
        end
        books << book
      end
      return books
    else
      book = Book.new(
        author: response.authors.author.name,
        cover: response.image_url,
        description: response.description,
        isbn: response.isbn,
        isbn13: response.isbn13,
        pages: response.num_pages,
        publication: Date.parse(response.work.publication_year.to_s + '-01-01'),
        publisher: response.publisher,
        rating: response.average_rating,
        title: response.title
      )
      unless response.work.original_publication_year.nil?
        if response.work.original_publication_year > 0
        book.original_publication = Date.parse(response.work.original_publication_year.to_s + '-01-01')
        else
          book.original_publication = Date.new(0003-01-01)
        end
      else
        book.original_publication = Date.new(0003-01-01)
      end
      return book
    end
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
            books << { book: Book.fetch_info(client.book_by_isbn(isbn_single)), message: 'ok' }
            books_found << isbn_single
            p isbn_single + ' => ok'
          rescue
            books << { book: nil, message: I18n.t('form.not_found') }
            books_not_found << isbn_single
            p isbn_single + ' => ko'
          end
        end
      else
        begin
          books << { book: Book.fetch_info(client.book_by_isbn(isbn)), message: 'ok' }
        rescue
          books << { book: nil, message: I18n.t('form.not_found') }
        end
      end
    elsif !options[:title].blank?
      begin
        books << { book: Book.fetch_info(client.book_by_title(options[:title])), message: 'ok' }
      rescue
        books << { book: nil, message: I18n.t('form.not_found') }
      end
    end
    if options[:user_id]
      books.each do |book|
        if book[:message] == 'ok'
          book[:book].user_id = options[:user_id]
        end
      end
    end
    if options[:save_search]
      books.each do |book|
        if book[:message] == 'ok'
          book[:book].save
        end
      end
    end
    result = { ok: [ books_found.size, books_found ], ko: [ books_not_found.size, books_not_found ] }
    p result.inspect
    return books
  end
end
