class Good < ActiveRecord::Base
  acts_as_list :scope => :category

  serialize :parameters
  serialize :variants
  serialize :similar

  belongs_to :category
  has_and_belongs_to_many :virtual_categories, :class_name => 'Category'
  
  has_many :good_parameters, 
           :dependent => :destroy
  
  has_many :attachments, 
           :as => :resource,
           :dependent => :destroy
  has_many :extra_attachments, 
           :as => :resource,
           :dependent => :destroy

  has_many :order_goods,
           :dependent => :restrict
  has_many :orders, :through => :order_goods

  #default_scope order('position ASC')
  scope :visible, where(:visible => true)
  scope :sorted, order("name asc")
  scope :site, visible.sorted
  
  scope :random, lambda { |cnt|
    order('random()').limit(cnt)
  }
  scope :not, lambda { |id|
    where(['id <> ?', id])
  }
  scope :has_virtual_category, lambda { |category|
    joins(:virtual_categories).
    where('categories_goods.category_id' => category.id)
  }

  scope :vc0_id_eq, lambda { |id|
    joins(:virtual_categories).where(['categories_goods.category_id = ?', id])
  }
  scope :vc1_id_eq, lambda { |id|
    joins(:virtual_categories).where(['categories_goods.category_id = ?', id])
  }
  search_methods :vc0_id_eq
  search_methods :vc1_id_eq

  
  validates :category, :presence => true
  validates :name, :presence => true, 
                   :length => { :maximum => 255 }
  validates :price, :presence => true,
                    :numericality => true 
  
  before_save :expand_parameters
  
  VISIBLE = "visible"
  INVISIBLE = "invisible"

  def variants
    {
      "weight" => []
    }.merge(super || {})
  end

  def nested_parameters
	  (self.parameters.nil? && !self.category.nil?) ? 
	      self.category.nested_parameters : self.parameters
	end

  def to_s
    self.name
  end

  def present_in?(category)
    return ( category.virtual && self.virtual_category_ids.include?(category.id) ) || 
    ( !category.virtual && self.category_id == category.id )
  end
  
  def attachment_styles
    { :big => "200x200", :small => "58x58", :cart => "81x81" } 
  end

  def status
    self.visible ? VISIBLE : INVISIBLE
  end

  def move_possible?(category)
    !category.virtual
  end

#private
  def expand_parameters
    self.good_parameters = []
    
    (self.parameters || []).each{ |p|
      self.good_parameters << GoodParameter.new(p)
    }
  end

end
