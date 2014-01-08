require 'active_support/core_ext/string/inflections'
require_relative 'uri_identifier'

class Lpa
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  #Using dynamic addition of new attributes
  include Mongoid::Attributes::Dynamic

  field :type, type: String
  field :when_to_use, type: String
  field :life_sustaining_treatment, type: String
  field :how_attorneys_act, type: String
  field :how_attorneys_act_details, type: String
  field :how_replacement_attorneys_act, type: String
  field :how_replacement_attorneys_act_details, type: String

  belongs_to :applicant

  embeds_one :donor
  embeds_one :certificate_provider
  embeds_one :certificate_provider2, class_name: 'CertificateProvider'

  embeds_many :people_to_be_told
  embeds_many :attorneys
  embeds_many :replacement_attorneys, class_name: 'Attorney'

  validates :type, presence: false, length: { minimum: 2, allow_blank: true }
  validates :when_to_use, presence: false, length: { minimum: 2, allow_blank: true }
  validates :life_sustaining_treatment, presence: false, length: { minimum: 2, allow_blank: true }
  validates :applicant, presence: true

  accepts_nested_attributes_for :attorneys, allow_destroy: true
  accepts_nested_attributes_for :replacement_attorneys, allow_destroy: true

  #Fields relevant for LPA Registration
  field :registration_applicants, type: Object
  validates :registration_applicants, presence: true

  include UriIdentifier

  entity do
    [
      :type,
      :when_to_use,
      :how_attorneys_act,
      :how_attorneys_act_details,
      :how_replacement_attorneys_act,
      :how_replacement_attorneys_act_details,
      :life_sustaining_treatment,
      :registration_applicants
    ].each do |attribute|
      expose attribute, if: lambda { |object, options| object.send(attribute) }
    end

    [
      :applicant,
      :donor,
      :attorneys,
      :replacement_attorneys,
      :certificate_provider,
      :people_to_be_told
    ].each do |attribute|
      model = Object.const_get(attribute.to_s.singularize.camelize.sub('Replacement',''))
      expose attribute, using: model.const_get(:Entity), if: lambda { |object, options| object.send(attribute) }
    end
    expose :certificate_provider2, using: CertificateProvider::Entity, if: lambda { |object, options| object.send(:certificate_provider2) }
  end
end
