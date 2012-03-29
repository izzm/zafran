class AddStaticPageOptions < ActiveRecord::Migration
  def change
    add_column :static_pages, :show_in_nav, :boolean, :default => false
    add_column :static_pages, :redirect_url, :string
  end
end
