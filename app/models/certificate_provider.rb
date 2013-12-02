require_relative 'personal_details'

class CertificateProvider
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails

  embedded_in :lpa

  entity do
    expose :email, if: ->(object, options) { object.email }
  end
end
