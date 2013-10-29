module PersonName
  extend ActiveSupport::Concern

  included do
    field :title,        type: String
    field :first_name,   type: String
    field :middle_names, type: String
    field :last_name,    type: String

    validates :first_name, presence: true, length: { minimum: 2 }
    validates :last_name,  presence: true, length: { minimum: 2 }

    entity do
      [ :title, :first_name, :middle_names, :last_name, :address ].each do |field|
        expose field, :if => lambda { |object, options| object.send(field) }
      end
    end
  end

  module InstanceMethods
  end
end
