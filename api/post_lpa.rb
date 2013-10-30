require_relative 'post_helpers'
require_relative 'error_helpers'

module Opg

  class PostLpa < Grape::API
    format :json

    helpers Opg::PostHelpers
    helpers Opg::ErrorHelpers

    resource :lpas do

      desc "Creates a LPA application."
      post do
        handle_post { |attributes| Lpa.create(attributes) }
      end

    end
  end

end

