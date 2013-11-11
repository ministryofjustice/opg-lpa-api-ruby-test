require_relative 'uri_identifier'
require_relative 'date_of_birth'
require_relative 'personal_details_with_phone'

class Applicant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  include UriIdentifier
  include DateOfBirth
  include PersonalDetailsWithPhone

  has_many :lpas
end

class LpaListDonor < Grape::Entity
  expose :first_name
  expose :middle_names
  expose :last_name
end

class LpaListItem < Grape::Entity
  expose :id do |instance, options|
    instance.id.to_s
  end
  expose :uri
  expose :donor, using: LpaListDonor
  expose :type
  expose :updated_at
end

class ApplicantWithLpas < Applicant::Entity
  expose :lpas, using: LpaListItem
end

