class StaticPage < ActiveRecord::Base
  acts_as_nested_set
  acts_as_list :scope => :parent
  acts_as_breadcrumbs(:attr => :url_path, :basename => :link, :separator => "/")

  scope :visible, where(:visible => true)
  scope :sorted,  order('position ASC')
  scope :navigation, visible.where(:show_in_nav => true).sorted
  scope :site_roots, where(:parent_id => nil)
  scope :site_children, lambda { |page|
    where(:parent_id => page.id).sorted.navigation
  }

  #default_scope order('position asc')
  has_many :attachments, 
           :as => :resource,
           :dependent => :destroy
  
  validates :title, :presence => true, 
                    :length => { :maximum => 255 }
  validates :content, :presence => true 
  validates :link, :presence => true,
                   :uniqueness => {:scope => :parent_id}

  VISIBLE = "visible"
  INVISIBLE = "invisible"

  def to_s
    self.title
  end
  
  def attachment_styles
    { :banner => "224x109#"} 
  end

  def status
    self.visible ? VISIBLE : INVISIBLE
  end
  
  def show_in_nav_status
    self.show_in_nav ? VISIBLE : INVISIBLE
  end

  def show_in_nav
    self.visible && super
  end
  
  def use_absolute_path?
    !redirect_url.blank?
  end
end
