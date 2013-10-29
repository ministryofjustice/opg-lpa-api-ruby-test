require_relative 'personal_details'

class Attorney
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails
end
