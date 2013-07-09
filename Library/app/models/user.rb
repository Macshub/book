class User < ActiveRecord::Base
  has_many :books
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def has_already_book?(isbn, isbn13)
    return self.books.map(&:isbn).include?(isbn) || self.books.map(&:isbn13).include?(isbn13)
  end
end
