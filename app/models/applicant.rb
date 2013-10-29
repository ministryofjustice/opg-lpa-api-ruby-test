require_relative 'personal_details'

class Applicant
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetails

  has_many :lpas

  def id
    _id.to_s
  end

  entity do
    expose :id
  end
end
