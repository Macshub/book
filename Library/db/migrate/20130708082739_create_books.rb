class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :user
      t.integer :isbn
      t.integer :isbn13
      t.string :title
      t.string :cover
      t.date :publication
      t.date :original_publication
      t.string :publisher
      t.text :description
      t.integer :author_id
      t.string :author_name
      t.float :rating
      t.integer :pages
      t.string :status
      t.boolean :lent
      t.text :record

      t.timestamps
    end
    add_index :books, :user_id
  end
end
