require 'active_support/core_ext/string/inflections'
require_relative 'identifier'

class Lpa
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  field :type, type: String
  field :when_to_use, type: String
  field :life_sustaining_treatment, type: String
  field :how_attorneys_act, type: String
  field :how_attorneys_act_details, type: String

  belongs_to :applicant

  embeds_one :donor
  embeds_one :certificate_provider

  embeds_many :attorneys
  embeds_many :replacement_attorneys, :class_name => 'Attorney'

  validates :type, presence: false, length: { minimum: 2, allow_blank: true }
  validates :when_to_use, presence: false, length: { minimum: 2, allow_blank: true }
  validates :life_sustaining_treatment, presence: false, length: { minimum: 2, allow_blank: true }
  validates :applicant, presence: true

  include Identifier

  entity do
    [
      :type,
      :when_to_use,
      :how_attorneys_act,
      :how_attorneys_act_details,
      :life_sustaining_treatment
    ].each do |attribute|
      expose attribute, if: lambda { |object, options| object.send(attribute) }
    end

    [
      :applicant,
      :donor,
      :attorneys,
      :replacement_attorneys,
      :certificate_provider
    ].each do |attribute|
      model = Object.const_get(attribute.to_s.camelize.singularize.sub('Replacement',''))
      expose attribute, using: model.const_get(:Entity), if: lambda { |object, options| object.send(attribute) }
    end
  end
end
