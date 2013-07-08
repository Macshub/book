class Book < ActiveRecord::Base
  belongs_to :user
  attr_accessible :author_name, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :record, :status, :title

  before_create do |book|
    book.lent ||= false
    book.record ||= nil
    book.status ||= 'model.book.status.to_buy'
  end

  validates_associated :user
  validates :author_name, :cover, :description, :isbn, :isbn13, :lent, :original_publication, :pages, :publication, :publisher, :rating, :status, :title, presence: true
  validates :isbn, length: { is: 9 }
  validates :isbn13, length: { is: 13 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :status, inclusion: { in: %w('model.book.status.to_buy', 'model.book.status.to_read', 'model.book.status.already_read') }
end
