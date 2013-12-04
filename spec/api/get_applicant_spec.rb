require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  describe "GET applicant with existing id" do
    before do
      lpa_id # creates applicant and lpa
    end

    shared_examples 'returns applicant JSON' do
      before do
        get "/api/applicants/#{supplied_id}", {}, { 'X-USER-ID' => email }
      end

      it 'returns 200' do
        last_response.status.should == 200
      end

      it 'returns JSON' do
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

    context 'when supplied id is applicant_id' do
      let(:supplied_id) { applicant_id }
      include_examples 'returns applicant JSON'
    end

    context 'when supplied id is :current' do
      let(:supplied_id) { :current }
      include_examples 'returns applicant JSON'
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
