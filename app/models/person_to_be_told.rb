require_relative 'personal_details'

class PersonToBeTold
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails

  embedded_in :lpa
end
