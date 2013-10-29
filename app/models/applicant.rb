require_relative 'identifier'
require_relative 'personal_details'

class Applicant
  include Mongoid::Document
  include Grape::Entity::DSL

  include Identifier
  include PersonalDetails

  has_many :lpas

end
