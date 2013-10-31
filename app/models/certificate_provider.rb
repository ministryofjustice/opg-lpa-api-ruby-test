require_relative 'personal_details'

class CertificateProvider
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails

  embedded_in :lpa
end
