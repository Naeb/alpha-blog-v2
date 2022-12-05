class RenameArticlesCategoriesTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :articles_categories, :article_categories
  end
end
