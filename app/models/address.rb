class Address
  include Mongoid::Document
  include Grape::Entity::DSL

  field :address_lines, type: Array
  field :town,          type: String
  field :county,        type: String
  field :postcode,      type: String
  field :country,       type: String

  embedded_in :addressable, polymorphic: true

  entity do
    [ :address_lines, :town, :county, :postcode, :country ].each do |field|
      expose field, :if => lambda { |object, options| object.send(field) }
    end
  end
end
