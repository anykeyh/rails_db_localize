class RailsDbLocalize::Translation < ActiveRecord::Base
  self.table_name = "rails_db_localize_translations"

  belongs_to :resource, polymorphic: true

  validates :resource_id, presence: true
  validates :resource_type, presence: true
  validates :field, presence: true
  validates :lang, presence: true
  validates :compound_key, presence: true

  validates :content, uniqueness: { scope: [:lang, :field, :resource_type, :resource_id] }

  scope :for_language, lambda { |x| where(lang: x) }
  scope :for_model, lambda { |m| where(resource_type: m.class, resource_id: m.id) }

  before_validation :set_compound_key

  def self.generate_ck resource_type, resource_id
    hash_long = [resource_type.to_s.underscore, resource_id].join("|").chars.map(&:ord).inject(5381) do |h, v|
      h += ((h<<5)+h)+v
    end

    #Keep it signed 32bits.
    hash_long & 0x7fffffff
  end

private
  def set_compound_key
    self.compound_key = RailsDbLocalize::Translation.generate_ck(resource_type, resource_id)
  end
end