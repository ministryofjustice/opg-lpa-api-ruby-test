require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  describe 'POST applicant with missing field' do
    it "should return 422 error" do
      post '/api/applicants', applicant_json.except('last_name')
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' => { 'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] } }
    end
  end

  describe 'POST applicant with blank field' do
    it "should return 422 error" do
      post '/api/applicants', applicant_json.merge('last_name' => '')
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" =>{ "last_name"=>["can't be blank", "is too short (minimum is 2 characters)"] } }
    end
  end

  describe "POST applicant including title, name, dob, and address postcode" do
    it 'should return 200 with JSON' do
      post '/api/applicants', applicant_json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response.except('id').should == applicant_json.merge("uri" => "http://example.org/api/applicants/#{response['id']}.json")
      response['id'].should_not be_nil
    end
  end

  describe 'POST applicant with unknown field' do
    it 'should return 422 error' do
      json = { 'first' => 'x' }
      post '/api/applicants', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Applicant."]}}
    end
  end

end
