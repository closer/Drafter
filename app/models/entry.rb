class Entry < ActiveRecord::Base
  has_many :entry_tags
  has_many :tags, :through => :entry_tags

  attr_accessible :title, :body, :tag_ids

  serialize :draft

  validates :title, presence: true
  validates :body, presence: true
  validates :tag_ids, :length => { :minimum => 1, :maximum => 3 }

  def draft_publish attributes = {}
    draft_update(attributes)
    result = false
    transaction do
      self.attributes = attributes
      unless result = self.save
        raise ActiveRecord::Rollback
      end
    end
    draft_update({}) if result
    result
  end

  def draft_load
    transaction do
      self.attributes = self.draft
      raise ActiveRecord::Rollback
    end
  end

  def draft_save attribtues = {}
    draft_update attribtues
    draft_valid?
  end

  def draft_update attributes
    self.class.record_timestamps = false
    update_attribute :draft, attributes
    self.class.record_timestamps = true
  end

  def draft_valid?
    result = false
    transaction do
      self.attributes = draft
      result = valid?
      raise ActiveRecord::Rollback
    end
    result
  end

end
