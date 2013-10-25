class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  field :title,        type: String
  field :first_name,   type: String
  field :middle_names, type: String
  field :last_name,    type: String

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name,  presence: true, length: { minimum: 2 }

  embeds_one :address, as: :addressable

  entity do
    [ :_id, :title, :first_name, :middle_names, :last_name, :address ].each do |field|
      expose field, :if => lambda { |object, options| object.send(field) }
    end

    expose :address, :using => Address::Entity, :if => lambda { |object, options| object.address }
  end
end
