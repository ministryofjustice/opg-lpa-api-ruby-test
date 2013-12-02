shared_context "shared LPA setup" do

  let(:dob) do
    { 'date_of_birth'=>'1988-10-10' }
  end

  let(:email) do
    '007@example.com'
  end

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' }, 'email' => email, 'phone' => '123 334' }
  end

  let(:applicant_json) do
    person_json.except('email').merge(dob)
  end

  let(:donor_json) do
    person_json.merge(dob)
  end

  let(:attorney_json) do
    person_json.merge(dob)
  end

  let(:applicant_id) do
    post '/api/applicants', applicant_json, { 'X-USER-ID' => email }
    response = JSON.parse last_response.body
    response['id']
  end

  let(:lpa_json) do
    json = {
      'applicant_id' => applicant_id, 'type' => 'health',
      'donor' => donor_json
    }
  end

  let(:lpa_id) do
    post '/api/lpas', lpa_json, { 'X-USER-ID' => email }
    response = JSON.parse last_response.body
    response['id']
  end
end
