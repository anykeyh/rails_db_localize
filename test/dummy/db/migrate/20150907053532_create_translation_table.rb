class CreateTranslationTable < ActiveRecord::Migration
  def change
    create_rails_db_localize_translations
  end
end
