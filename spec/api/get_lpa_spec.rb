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

  describe "GET lpa with existing id" do
    it 'should return JSON' do
      get "/api/lpas/#{lpa_id}"
      response = JSON.parse last_response.body
      response['id'].should == lpa_id
    end
  end

  describe "GET lpa with invalid id" do
    it 'should return 404' do
      get "/api/lpas/xxyyzz"
      last_response.status.should == 404
      last_response.body.should == '{"error":"Document(s) not found for class Lpa with id(s) xxyyzz."}'
    end
  end
end
