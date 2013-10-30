require_relative 'identifier'

class Lpa
  include Mongoid::Document
  include Grape::Entity::DSL

  field :type, type: String
  field :when_to_use, type: String

  belongs_to :applicant

  embeds_one :donor

  embeds_many :attorneys

  validates :type, presence: false, length: { minimum: 2, allow_blank: true }
  validates :when_to_use, presence: false, length: { minimum: 2, allow_blank: true }
  validates :applicant, presence: true

  include Identifier

  entity do
    expose :type, if: lambda { |object, options| object.type }
    expose :when_to_use, if: lambda { |object, options| object.type }

    expose :applicant, using: Applicant::Entity, if: lambda { |object, options| object.applicant }
    expose :donor,     using: Donor::Entity,     if: lambda { |object, options| object.donor }
    expose :attorneys, using: Attorney::Entity,  if: lambda { |object, options| object.attorneys }
  end
end
