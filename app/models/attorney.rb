require_relative 'date_of_birth'
require_relative 'personal_details_with_phone'

class Attorney
  include Mongoid::Document
  include Grape::Entity::DSL

  include DateOfBirth
  include PersonalDetailsWithPhone

  embedded_in :lpa

end
