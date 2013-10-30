require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  include_context "shared LPA setup"

  describe "GET applicant with existing id" do
    before do
      lpa_id # creates applicant and lpa
    end
    it 'should return JSON' do
      get "/api/applicants/#{applicant_id}"
      response = JSON.parse last_response.body
      response['id'].should == applicant_id
      puts "response: " + last_response.body
      response['lpas'].should == [
        {
          "id"=>lpa_id,
          "uri"=>"http://example.org/api/lpas/#{lpa_id}.json",
          "donor"=>{"first_name"=>"James", "middle_names"=>nil, "last_name"=>"Bond"},
          "type"=>"health"
        }
      ]
      puts response
    end
  end

  describe "GET applicant with invalid id" do
    it 'should return 404' do
      get "/api/applicants/xxyyzz"
      last_response.status.should == 404
      last_response.body.should == '{"error":"Document(s) not found for class Applicant with id(s) xxyyzz."}'
    end
  end
end
