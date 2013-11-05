require_relative 'date_of_birth'
require_relative 'personal_details'

class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  include DateOfBirth
  include PersonalDetails

  embedded_in :lpa

end
