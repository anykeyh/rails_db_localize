class TranslatablesController < ApplicationController
  def index
    @translatables = Translatable.where(nil)
    preload_translations_for(@translatables)
  end

  def set_tr
    require 'faker'

    @translatable = Translatable.find(params[:id])
    @translatable.name_translated = Faker::Lorem.paragraph, params[:lang]
    @translatable.save!

    redirect_to "/"
  end
end
