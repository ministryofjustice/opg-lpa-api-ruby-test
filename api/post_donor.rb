module Lpa
  class PostDonor < Grape::API
    format :json
    desc "Creates a donor."
    resource :donor do
      post do
        donor = Donor.create(params['donor']) #
        if donor.persisted?
          present donor, with: Donor::Entity
        else
          error!({ messages: donor.errors.messages }, 400)
        end
      end
    end
  end
end

