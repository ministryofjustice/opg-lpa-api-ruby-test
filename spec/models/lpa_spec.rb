require 'spec_helper'

describe Lpa do

  let(:person_json) do
    { title: 'Mr', first_name: 'James', last_name: 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  let(:applicant) do
    applicant = Applicant.new person_json
    applicant.save
    applicant
  end

  it "should be valid with nil type" do
    Lpa.new(applicant_id: applicant.id).should be_valid
  end

  it "should not be valid with blank type" do
    Lpa.new(applicant_id: applicant.id, :type => "").should be_valid
  end

  it "should be valid with valid type" do
    Lpa.new(applicant_id: applicant.id, :type => "Property and financial affairs").should be_valid
  end
end