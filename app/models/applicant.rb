require_relative 'identifier'
require_relative 'personal_details'

class Applicant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  include Identifier
  include PersonalDetails

  has_many :lpas
end

class LpaListDonor < Grape::Entity
  expose :first_name
  expose :middle_names
  expose :last_name
end

class LpaListItem < Grape::Entity
  expose :id
  expose :uri
  expose :donor, using: LpaListDonor
  expose :type
end

class ApplicantWithLpas < Applicant::Entity
  expose :lpas, using: LpaListItem
end

