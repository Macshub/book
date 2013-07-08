class RemoveAuthorIdFromBooks < ActiveRecord::Migration
  def up
    remove_column :books, :author_id
  end

  def down
    add_column :books, :author_id, :integer
  end
end
