class Good < ActiveRecord::Base
  acts_as_list :scope => :category

  scope :visible, where(:visible => true)
  scope :sorted,  order('position ASC')

  serialize :parameters

  belongs_to :category
  has_and_belongs_to_many :virtual_categories, :class_name => 'Category'
  
  has_many :attachments, 
           :as => :resource,
           :dependent => :destroy

  validates :name, :presence => true, 
                   :length => { :maximum => 255 }
  validates :price, :presence => true,
                    :numericality => true 

  def nested_parameters
	  (self.parameters.nil? && !self.category.nil?) ? 
	      self.category.nested_parameters : self.parameters
	end

  def to_s
    self.title
  end

  def present_in?(category)
    return ( category.virtual && self.virtual_category_ids.include?(category.id) ) || 
    ( !category.virtual && self.category_id == category.id )
  end
  
  def attachment_styles
    { :preview => "219x134#", :big => "350x245#", :small => "66x66#" } 
  end

end
