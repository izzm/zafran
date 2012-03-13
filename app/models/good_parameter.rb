class GoodParameter < ActiveRecord::Base
  belongs_to :good
  
  def self.value_list(name)
    self.select('distinct value').where(:name => name).collect(&:value)
  end
end
