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

      attributes
    end

    def self.destroy_attorneys lpa, attributes, attorney_relation
      if attributes[attorney_relation] && attributes[attorney_relation].any?{|x| x.has_key?('_destroy')}
        attorneys = attributes.delete(attorney_relation)
        lpa.send("#{attorney_relation}_attributes=".to_sym, attorneys)
        lpa.save! # deletes attorney if _destroy in its hash
        true
      else
        false
      end
    end

    resource :lpas do

      route_param :id do
        desc "PUT a LPA application."
        params do
          requires :id, type: String, desc: "LPA application ID."
        end
        put do

          attributes = PutLpa.clean_attributes params
          begin
            lpa = Lpa.find(attributes['id'])

            if PutLpa.destroy_attorneys(lpa, attributes, 'attorneys') ||
                PutLpa.destroy_attorneys(lpa, attributes, 'replacement_attorneys')
              # done
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

