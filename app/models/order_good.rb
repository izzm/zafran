class OrderGood < ActiveRecord::Base
  belongs_to :order
  belongs_to :good

  serialize :variant

  before_save :set_default_count, :set_default_price

  def variant
    super || {}
  end

private
  def set_default_count
    self.count ||= 1
  end

  def set_default_price
    self.price ||= self.good.try(:price)
  end
end
