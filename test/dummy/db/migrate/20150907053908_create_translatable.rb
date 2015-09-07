class CreateTranslatable < ActiveRecord::Migration
  def change
    create_table :translatables do |t|
      t.string :name
    end
  end
end
