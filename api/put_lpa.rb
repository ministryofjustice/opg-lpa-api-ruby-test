require_relative 'error_helpers'

module Opg

  class PutLpa < Grape::API
    format :json

    helpers Opg::ErrorHelpers

    resource :lpas do

      route_param :id do
        desc "PUT a LPA application."
        params do
          requires :id, type: String, desc: "LPA application ID."
        end
        put do
          begin
            lpa = Lpa.find(params[:id])

            attributes = params.except('route_info','format')
            def attributes.permitted?; true; end

            lpa.update_attributes!(attributes)

            present lpa, with: Lpa::Entity
          rescue Mongoid::Errors::DocumentNotFound => e
            error!(mongoid_exception_message(e), 404)
          end

        end
      end
    end
  end

end

