ActiveAdmin.register StaticPage do
  filter :title
  scope :roots, :default => :true

  form :partial => 'form'

  controller do
    def index
      redirect_to index_tree_admin_static_pages_path
    end
    
    def new
      @static_page = StaticPage.new
      @static_page.visible ||= true
      @static_page.show_in_nav ||= true
    end
    
    def show
      #redirect_to edit_admin_static_page_path(@page)
      redirect_to index_tree_admin_static_pages_path
    end
  end

  collection_action :index_tree, :method => :get do
    @static_pages = StaticPage.arrange
    @page_title = I18n.t('active_admin.titles.static_page.index_tree')

    render :action => 'blank' if @static_pages.blank?
  end

  member_action :move_higher, :method => :put do
    static_page = StaticPage.find(params[:id])
    static_page.move_higher
    
    redirect_to index_tree_admin_static_pages_path
  end

  member_action :move_lower, :method => :put do
    static_page = StaticPage.find(params[:id])
    static_page.move_lower
    
    redirect_to index_tree_admin_static_pages_path
  end

  
  sidebar I18n.t('active_admin.titles.static_page.tree'), :only => [:edit]  do |page|
    render :partial => 'page_tree',
           :locals => {:current_page => static_page,
                       :link => :edit}
  end 
end
