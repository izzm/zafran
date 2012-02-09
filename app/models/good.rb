class Good < ActiveRecord::Base
  acts_as_list :scope => :category

  serialize :parameters
  serialize :variants
  serialize :similar

  belongs_to :category
  has_and_belongs_to_many :virtual_categories, :class_name => 'Category'
  
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
  
  VISIBLE = "visible"
  INVISIBLE = "invisible"

  def variants
    {
      "color" => [],
      "cloth" => [],
      "size" => []
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
    { :preview => "219x165", :big => "350x263", :small => "66x66", :cart => "101x80", :compare => "184x111" } 
  end

  def status
    self.visible ? VISIBLE : INVISIBLE
  end

  def move_possible?(category)
    !category.virtual
  end

end
