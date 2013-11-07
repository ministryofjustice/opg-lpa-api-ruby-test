require_relative 'error_helpers'

module Opg

  class PutLpa < Grape::API
    format :json

    helpers Opg::ErrorHelpers

    def self.clean_attributes params
      attributes = params.except('route_info','format','uri').to_hash
      def attributes.permitted?; true; end
      if attributes['applicant']
        applicant = attributes.delete('applicant')
        attributes['applicant_id'] = applicant['id']
      end
      puts attributes
      attributes
    end

    resource :lpas do

      route_param :id do
        desc "PUT a LPA application."
        params do
          requires :id, type: String, desc: "LPA application ID."
        end
        put do
          begin
            attributes = PutLpa.clean_attributes params
            id = attributes.delete('id')
            lpa = Lpa.find(id)

            if attributes['attorneys'] && attributes['attorneys'].any?{|x| x.has_key?('_destroy')} && (attorneys = attributes.delete('attorneys'))
              lpa.attorneys_attributes = attorneys
              lpa.save! # deletes attorney if _destroy in its hash
            else
              lpa.update_attributes(attributes)
            end

            if lpa.valid?
              present lpa, with: Lpa::Entity
            else
              unprocessable_entity_error! error_messages(lpa)
            end

          rescue Mongoid::Errors::DocumentNotFound => e
            error!(mongoid_exception_message(e), 404)
          end

        end
      end
    end
  end

end

