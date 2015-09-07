class ActiveRecord::Migration
  def create_rails_db_localize_translations
    self.create_table :rails_db_localize_translations do |t|
        t.string :resource_type, index: true
        t.integer :resource_id, index: true

        t.string :field, index: true
        t.string :lang, index: true
        t.integer :compound_key, index: true

        t.text :content
        t.timestamp
    end

    add_index :rails_db_localize_translations, [:resource_id, :resource_type], name: "index_rdblt_it"
    add_index :rails_db_localize_translations, [:resource_id, :resource_type, :field], name: "index_rdblt_itf"
    add_index :rails_db_localize_translations, [:resource_id, :resource_type, :field, :lang], name: "index_rdblt_itfl"
    add_index :rails_db_localize_translations, [:compound_key, :field], name: "index_rdblt_cf"
    add_index :rails_db_localize_translations, [:compound_key, :field, :lang], name: "index_rdblt_cfl"
  end
end