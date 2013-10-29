require_relative 'post_helpers'
require_relative 'error_helpers'

module Opg
  class PostApplicant < Grape::API
    format :json

    helpers Opg::PostHelpers
    helpers Opg::ErrorHelpers

    desc "Creates an LPA applicant."
    resource :applicants do
      post do
        handle_post { |attributes| Applicant.create(attributes) }
      end
    end
  end

end

