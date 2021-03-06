class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :user
      t.integer :isbn, :limit => 5
      t.integer :isbn13, :limit => 5
      t.string :title
      t.string :cover
      t.date :publication
      t.date :original_publication
      t.string :publisher
      t.text :description
      t.string :author
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
