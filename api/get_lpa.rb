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
          user_id = request.env['X-USER-ID']

          begin
            lpa = Lpa.find(params[:id])
            applicant = lpa.applicant

            if applicant.email == user_id
              present lpa, with: Lpa::Entity
            else
              error!('Forbidden', 403)
            end
          rescue Mongoid::Errors::DocumentNotFound => e
            error!('Forbidden', 403)
          end

        end
      end
    end
  end

end

