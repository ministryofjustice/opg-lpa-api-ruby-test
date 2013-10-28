require_relative 'personal_details'

class Applicant
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails

  entity do
    expose :_id
  end
end
