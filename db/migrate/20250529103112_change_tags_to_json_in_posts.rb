class ChangeTagsToJsonInPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :tags, :string
    add_column :posts, :tags, :jsonb, default: []
  end
end
