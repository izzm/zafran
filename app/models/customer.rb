class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  #devise :database_authenticatable, :registerable, :confirmable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #apply_simple_captcha :always_check => true, :on => [:create]
  validates :name, :presence => true
  validates :email, :presence => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :company, :corporate, :phone, :email, :password, :password_confirmation, :remember_me

  scope :all_customers, where("1=1") # Ugly hack for active admin
  scope :individual, where(:corporate => false)
  scope :corporate, where(:corporate => true)

  has_many :orders
  has_many :wishlist_goods, :dependent => :destroy
  has_many :goods, :through => :wishlist_goods
  
  accepts_nested_attributes_for :orders
  
  def set_first_order!(order)
    self.first_order ||= order.created_at
    self.save
  end

  def name_with_email
    "#{self.name} (#{self.email})"
  end

  def update_with_password(params={})
    if params[:password].nil?
      params.delete(:current_password)
      self.update_without_password(params)
    else
      super params
    end
  end
end
