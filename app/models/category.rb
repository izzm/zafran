class Category < ActiveRecord::Base
  acts_as_nested_set
  acts_as_list :scope => :parent
  acts_as_breadcrumbs(:attr => :url_path, :basename => :link, :separator => "/")

  scope :visible, where(:visible => true)
  scope :sorted,  order('position ASC')
  #scope :nested_set,          order('lft ASC')
  #scope :reversed_nested_set, order('lft DESC')
  scope :virtual, where(:virtual => true)

	serialize :parameters
	
  has_many :goods, :dependent => :destroy
  has_and_belongs_to_many :virtual_goods, :class_name => 'Good'
    
  has_many :attachments, 
           :as => :resource,
           :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :description
	validates_presence_of :link
  validates_uniqueness_of :link, :scope => :parent_id

  validates :name, :presence => true, 
                   :length => { :maximum => 255 }
  validates :description, :presence => true 
  validates :link, :presence => true,
                   :uniqueness => {:scope => :parent_id}
  
  VISIBLE = "visible"
  INVISIBLE = "invisible"

  def site_goods
    self.parent.try(:virtual) ? self.virtual_goods : 
                                self.self_and_descendants_goods
  end

  def self_and_descendants_goods
    ids =  self.self_and_descendants.map { |cat|
      cat.id
    }

    Good.where(:category_id => ids)
  end

  def can_be_virtual?
    (self.parent.nil? || !self.parent.virtual) && !self.new_record?
  end
  
  def can_have_subcats?
    self.parent.nil? || !self.parent.virtual
  end
  
  def can_move?
    self.parent.nil? || !self.parent.virtual
  end
  
  def can_have_goods?
    (self.parent.nil? || !self.parent.virtual) && !self.virtual
  end

	def nested_parameters
	  (self.parameters.nil? && !self.parent.nil?) ? 
	      self.parent.nested_parameters : self.parameters
	end

  def to_s
    self.name
  end

  def status
    self.visible ? VISIBLE : INVISIBLE
  end
  
  def attachment_styles
    { :big => "200x200", :small => "58x58", :cart => "81x81" } 
  end

end
