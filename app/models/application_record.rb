class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  cattr_accessor :skip_callbacks
end
