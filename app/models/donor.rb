require_relative 'date_of_birth'
require_relative 'personal_details_with_phone'

class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  include DateOfBirth
  include PersonalDetailsWithPhone

  embedded_in :lpa

  entity do
    expose :email, if: ->(object, options) { object.email }
  end
end
