class Tag < ActiveRecord::Base
  has_many :entry_tags
  has_many :enries, :through => :entry_tags
end
