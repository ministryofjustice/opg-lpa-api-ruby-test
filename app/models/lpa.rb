class Lpa
  include Mongoid::Document
  include Grape::Entity::DSL

  field :type, type: String

  embeds_one :applicant

  embeds_one :donor

  embeds_many :attorneys

  validates :type, presence: false, length: { minimum: 2, allow_blank: true }

  entity do
    [ :_id, :type ].each do |field|
      expose field, if: lambda { |object, options| object.send(field) }
    end

    expose :applicant, using: Applicant::Entity, if: lambda { |object, options| object.applicant }
    expose :donor,     using: Donor::Entity,     if: lambda { |object, options| object.donor }
    expose :attorneys, using: Attorney::Entity,  if: lambda { |object, options| object.attorneys }
  end
end
