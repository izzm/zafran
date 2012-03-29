module ApplicationHelper
  def render_table_tree(hash, options = {}, &block)
    sort_proc = options.delete :sort
    hash.keys.sort_by(&sort_proc).each do |node|
      block.call node
      render_table_tree(hash[node], :sort => sort_proc, &block)  
    end if hash.present?
  end
  
  # METHODS FOR SITE FRONTEND
  
  def site_main_menu
    StaticPage.find_by_link('main').children.navigation
  end
  
  def site_extra_menu
    StaticPage.find_by_link('extra').children.navigation
  end
  
  def static_page(page)
    page.use_absolute_path? ? 
      page.redirect_url :
      static_page_path(page.url_path)
  end
end
