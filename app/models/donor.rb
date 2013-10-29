require_relative 'personal_details'

class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails
end
