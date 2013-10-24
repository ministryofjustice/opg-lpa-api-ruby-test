require 'spec_helper'
require 'active_resource'
require 'active_racksource'

# ActiveResource::Base.app = Lpa::API

class DonorResource < ActiveResource::Base
  self.site = "http://localhost:9292/api"
  # self.site = "http://localhost:#{ENV['TEST_PORT']}/api"
  self.element_name = "donor"
  puts "site: #{self.site}"
end

describe Lpa::API do
  include Rack::Test::Methods

  def app
    Lpa::API
  end

  describe 'POST donor title, first_name' do
    it "should return 422 error" do
      json = { 'title' => 'Mr', 'first_name' => 'James' }
      post "/api/donors", json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"last_name"=>["can't be blank"]}}
    end
  end

  describe "POST donor title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => 'Bond', 'address' => {'postcode' => 'N1'} }
      post "/api/donors", json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response.except('_id').should == json
      response['_id'].should_not be_nil
    end
  end

  context "calling API via ActiveResource" do

    describe 'save Donor missing required fields' do
      it 'should return errors' do
        donor = DonorResource.new(first: 'Donor')
        donor.new?.should == true
        begin
        donor.save.should == false
      rescue Exception => e
        # binding.pry
        raise e
      end
        donor.new?.should == true
        donor.id.should == nil
      end
    end

    describe 'save Donor with required fields' do
      it 'should have created donor' do
        values = { title: 'Mr', first_name: 'James', last_name: 'Bond' }
        donor = DonorResource.new(values)
        donor.new?.should == true
        donor.save.should == true
        donor.new?.should == false
        donor.id.should == nil
      end
    end
  end

end
