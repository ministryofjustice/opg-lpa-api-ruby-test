require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  describe "GET applicant with existing id" do
    before do
      lpa_id # creates applicant and lpa
    end
    it 'returns JSON' do
      get "/api/applicants/#{applicant_id}", {}, { 'X-USER-ID' => email }
      response = JSON.parse last_response.body
      response['id'].should == applicant_id

      updated_at = response['lpas'].first.delete('updated_at')
      response['lpas'].should == [
        {
          "id"=>lpa_id,
          "uri"=>"http://example.org/api/lpas/#{lpa_id}.json",
          "donor"=>{"first_name"=>"James", "middle_names"=>nil, "last_name"=>"Bond"},
          "type"=>"health"
        }
      ]
      updated_at.should_not be_nil
    end
  end

  describe "GET applicant with invalid id" do
    it 'returns 403 Forbidden' do
      get "/api/applicants/xxyyzz", {}, { 'X-USER-ID' => email }
      last_response.status.should == 403
      last_response.body.should == '{"error":"Forbidden"}'
    end
  end

  describe "GET applicant when authenticated user is not the applicant" do
    before do
      lpa_id # creates applicant and lpa
      get "/api/applicants/#{applicant_id}", {}, { 'X-USER-ID' => 'bad_user@example.com' }
    end

    it 'returns 403 Forbidden' do
      last_response.status.should == 403
      last_response.body.should == '{"error":"Forbidden"}'
    end
  end

end
