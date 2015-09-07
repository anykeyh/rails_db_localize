class RailsDbLocalize::Translation < ActiveRecord::Base
  self.table_name = "rails_db_localize_translations"

  belongs_to :resource, polymorphic: true

  validates :resource_id, presence: true
  validates :resource_type, presence: true
  validates :field, presence: true
  validates :lang, presence: true
  validates :compound_key, presence: true

  validates :content, uniqueness: { scope: [:lang, :field, :resource_type, :resource_id] }

  scope :with_language, lambda { |x| where("lang LIKE ?", "#{x}%") }

  before_validation :set_compound_key



  def self.generate_ck resource_type, resource_id
    hash_long = [resource_type.to_s.underscore, resource_id].join("|").chars.map(&:ord).inject(5381) do |h, v|
      h = ((h<<5)+h)+v
    end

    #Keep it signed 32bits.
    hash_long & 0x7fffffff
  end


   def self.get_untranslated model, field, lang
    model.where("id NOT IN (?)",
      [-1, *RailsDbLocalize::Translation.where(resource_type: k.to_s, lang: lang, field: field).pluck(:resource_id).uniq]
    )
  end

private
  def set_compound_key
    self.compound_key = RailsDbLocalize::Translation.generate_ck(resource_type, resource_id)
  end
end