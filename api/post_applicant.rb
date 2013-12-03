require_relative 'post_helpers'
require_relative 'error_helpers'

module Opg
  class PostApplicant < Grape::API
    format :json

    helpers Opg::PostHelpers
    helpers Opg::ErrorHelpers

    resource :applicants do

      desc "Creates an LPA applicant."
      post do
        handle_post do |attributes, user_id|
          if Applicant.where(email: user_id).exists?
            error!('Forbidden', 403)
          else
            attributes = attributes.merge(email: user_id)
            Applicant.create(attributes)
          end
        end
      end

    end
  end

end

