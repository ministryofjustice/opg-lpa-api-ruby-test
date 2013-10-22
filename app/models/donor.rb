class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  field :title,        type: String
  field :first_name,   type: String
  field :middle_names, type: String
  field :last_name,    type: String

  entity do
    [ :_id, :title, :first_name, :middle_names, :last_name ].each do |field|
      expose field, :if => lambda { |object, options| object.send(field) }
    end
  end
end
