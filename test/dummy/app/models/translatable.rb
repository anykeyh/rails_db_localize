class Translatable < ActiveRecord::Base
  has_translations :name
end