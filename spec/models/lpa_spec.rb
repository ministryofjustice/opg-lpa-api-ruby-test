require 'spec_helper'
require_relative '../api/shared_lpa_setup'

describe Lpa do

  include_context "shared LPA setup"

  let(:applicant) do
    applicant = Applicant.new applicant_json
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