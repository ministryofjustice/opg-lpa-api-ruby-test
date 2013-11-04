module DateOfBirth
  extend ActiveSupport::Concern

  included do
    field :date_of_birth, type: Date

    validates :date_of_birth, presence: true

    entity do
      expose :date_of_birth, :if => lambda { |object, options| object.date_of_birth }
    end
  end
end
