require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  def post_applicant params
    post '/api/applicants', params, { 'X-USER-ID' => email }
  end

  describe 'POST applicant with missing field' do
    it "returns 422 error" do
      post_applicant applicant_json.except('last_name')
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' => { 'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] } }
    end
  end

  describe 'POST applicant with blank field' do
    it "returns 422 error" do
      post_applicant applicant_json.merge('last_name' => '')
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" =>{ "last_name"=>["can't be blank", "is too short (minimum is 2 characters)"] } }
    end
  end

  describe "POST applicant with valid params" do
    before do
      post_applicant applicant_json
      @response = JSON.parse last_response.body
    end

    it 'returns 201 with JSON' do
      last_response.status.should == 201
    end

    it 'returns applicant JSON' do
      response = JSON.parse last_response.body
      expected_values = applicant_json.merge('uri' => "http://example.org/api/applicants/#{response['id']}.json")

      @response.except('id').should == expected_values
    end

    it 'returns applicant id in JSON' do
      @response['id'].should_not be_nil
    end

    it 'does not return email in JSON' do
      @response['email'].should be_nil
    end

    it 'sets X-USER-ID value as email on Applicant' do
      Applicant.last.email.should == email
    end
  end

  describe "POST applicant with valid params when applicant already exists for authenticated user" do

    it 'returns 403 Forbidden' do
      post_applicant applicant_json
      post_applicant applicant_json

      last_response.status.should == 403
    end
  end

  describe 'POST applicant with unknown field' do
    it 'returns 422 error' do
      json = { 'first' => 'x' }
      post_applicant json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Applicant."]}}
    end
  end

end
