require 'spec_helper'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  let(:applicant_id) do
    post '/api/applicants', person_json
    response = JSON.parse last_response.body
    response['id']
  end

  let(:lpa_id) do
    json = {
      'applicant_id' => applicant_id, 'type' => 'health',
      'donor' => person_json
    }
    post '/api/lpas', json
    response = JSON.parse last_response.body
    response['id']
  end

  describe "PUT lpa with existing id" do
    it 'should return JSON' do
      json = { 'type' => 'financial' }
      put "/api/lpas/#{lpa_id}", json
      puts last_response.body
      response = JSON.parse last_response.body
      response['type'].should == 'financial'
    end
  end

  describe "PUT lpa with donor field blank" do
    it 'should return JSON' do
      json = { 'donor' => person_json.merge('last_name' => '') }
      put "/api/lpas/#{lpa_id}", json
      puts last_response.body
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

end