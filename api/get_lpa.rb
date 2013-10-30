require_relative 'error_helpers'

module Opg

  class GetLpa < Grape::API
    format :json

    helpers Opg::ErrorHelpers

    resource :lpas do

      route_param :id do
        desc "Get an LPA application."
        params do
          requires :id, type: String, desc: "LPA application ID."
        end
        get do
          begin
            lpa = Lpa.find(params[:id])
            present lpa, with: Lpa::Entity
          rescue Mongoid::Errors::DocumentNotFound => e
            error!(mongoid_exception_message(e), 404)
          end

        end
      end
    end
  end

end

