require 'action_controller/base'

class ActionController::Base

  before_action :prepare_translation_cache

  # Preload the translations string for all the collections.
  # This allow to load all translation resources in only one SQL query.
  # Take in consideration this will execute the request for
  def preload_translations_for *collections
    RailsDbLocalize::TranslationCache.instance.prefetch_collections(*collections)
  end

private
  def prepare_translation_cache
    RailsDbLocalize::TranslationCache.reinit
    yield if block_given?
  end
end