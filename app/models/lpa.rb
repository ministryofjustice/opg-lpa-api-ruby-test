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

  embeds_many :attorneys
  embeds_many :replacement_attorneys, :class_name => 'Attorney'

  validates :type, presence: false, length: { minimum: 2, allow_blank: true }
  validates :when_to_use, presence: false, length: { minimum: 2, allow_blank: true }
  validates :life_sustaining_treatment, presence: false, length: { minimum: 2, allow_blank: true }
  validates :applicant, presence: true

  include Identifier

  entity do
    expose :type, if: lambda { |object, options| object.type }
    expose :when_to_use, if: lambda { |object, options| object.when_to_use }
    expose :how_attorneys_act, if: lambda { |object, options| object.how_attorneys_act }
    expose :how_attorneys_act_details, if: lambda { |object, options| object.how_attorneys_act_details }

    expose :applicant, using: Applicant::Entity, if: lambda { |object, options| object.applicant }
    expose :donor,     using: Donor::Entity,     if: lambda { |object, options| object.donor }
    expose :attorneys, using: Attorney::Entity,  if: lambda { |object, options| object.attorneys }
    expose :replacement_attorneys, using: Attorney::Entity,  if: lambda { |object, options| object.replacement_attorneys }
  end
end
