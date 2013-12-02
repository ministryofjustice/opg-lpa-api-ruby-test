require_relative 'error_helpers'

module Opg

  class GetApplicant < Grape::API
    format :json

    helpers Opg::ErrorHelpers

    resource :applicants do

      route_param :id do
        desc "Get an LPA applicant.", { notes: <<-NOTE
Returns Applicant
-----------------

Example response JSON:

    {
      "id"=>"52712951526f620667000000",
      "uri"=>"http://example.org/api/applicants/52712951526f620667000000.json",
      "title"=>"Mr",
      "first_name"=>"James",
      "last_name"=>"Bond",
      "address"=> {
        "post_code"=>"N1"
      },
      "lpas"=> [
        {
          "id"=>"52713384526f621f67130000",
          "uri"=>"http://example.org/api/lpas/52713384526f621f67130000.json",
          "donor"=>"Mr James Bond",
          "type"=>"health",
          "updated_at"=>"",
          "status"=>"Started"
        }
      ]
    }

NOTE
}
        params do
          requires :id, type: String, desc: "LPA applicant ID."
        end
        get do
          begin
            user_id = request.env['X-USER-ID']
            applicant = Applicant.includes(:lpas).find(params[:id])
            if applicant.email == user_id
              present applicant, with: ApplicantWithLpas
            else
              error!('', 403)
            end
          rescue Mongoid::Errors::DocumentNotFound => e
            error!(mongoid_exception_message(e), 404)
          end
        end
      end
    end
  end

end

