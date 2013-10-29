module Opg

  class GetLpa < Grape::API
    format :json

    resource :lpas do

      route_param :id do
        desc "Get an LPA application."
        params do
          requires :id, type: String, desc: "LPA application ID."
        end
        get do
          lpa = Lpa.find(params[:id])
          present lpa, with: Lpa::Entity
        end
      end
    end
  end

end

