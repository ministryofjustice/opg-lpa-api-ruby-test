require_relative 'personal_details_with_phone'

class PersonToBeTold
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetailsWithPhone

  embedded_in :lpa
end
