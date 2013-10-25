class Address
  include Mongoid::Document
  include Grape::Entity::DSL

  field :address_line1, type: String
  field :address_line2, type: String
  field :address_line3, type: String
  field :town,          type: String
  field :county,        type: String
  field :post_code,      type: String
  field :country,       type: String

  embedded_in :addressable, polymorphic: true

  entity do
    [ :address_lines1, :address_lines2, :address_lines3, :town, :county, :post_code, :country ].each do |field|
      expose field, :if => lambda { |object, options| object.send(field) }
    end
  end
end
