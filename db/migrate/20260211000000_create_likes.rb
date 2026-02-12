class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    # 同じユーザーが同じ投稿に複数回いいねするのを防ぐ
    add_index :likes, [:post_id, :user_id], unique: true
  end
end
