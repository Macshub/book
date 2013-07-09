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
end
