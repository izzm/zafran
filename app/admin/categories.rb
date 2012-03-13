ActiveAdmin.register Category do
  form :partial => 'form'

  controller do
    def index
      redirect_to index_tree_admin_categories_path
    end

    def new
      @category = Category.new
      @category.parent_id ||= params[:parent_id]
      @category.visible ||= true
    end

    def show
      redirect_to index_tree_admin_categories_path
    end
  end
  
  collection_action :recalcualte_all_goods, :method => :get do
    Good.all.each { |g| g.expand_parameters }
    
    render :text => "OK"
  end

  collection_action :index_tree, :method => :get do
    @categories = Category.arrange
    @page_title = I18n.t('active_admin.titles.category.index_tree')

    render :action => 'blank' if @categories.blank?
  end
 
  member_action :move_higher, :method => :put do
    category = Category.find(params[:id])
    category.move_higher
    
    redirect_to index_tree_admin_categories_path
  end

  member_action :move_lower, :method => :put do
    category = Category.find(params[:id])
    category.move_lower
    
    redirect_to index_tree_admin_categories_path
  end
 
  sidebar I18n.t('active_admin.titles.category.tree'),  
          :only => [:edit]  do |page|
    render :partial => 'category_tree',
           :locals => {:current_page => category,
                       :link => :edit}
  end 
 
end
