require 'helper'

class ContactsTest < Minitest::Test
  def setup
    # TODO: Copy a valid, non-expired access token here.
    @token = 'eyJ0eXAiOiJKV1QiLCJhbGciO...' # access_ token

    @test_response = {'body'=>'ok'}
    faraday_instance = Faraday.new() do |faraday|
      stubs = Faraday::Adapter::Test::Stubs.new
      faraday.adapter :test, stubs do |stub|
        stub.get('/api/v1.0/Me/Contacts') { |env| [200, {}, @test_response.to_json ] }
        stub.get('/api/v1.0/Me/Contacts/conid') { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/Contacts") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.patch("/api/v1.0/Me/Contacts/conid") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.delete("/api/v1.0/Me/Contacts/conid") { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/SendMail") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
      end
    end
    @outlook_client = O365::Client.new faraday_instance: faraday_instance
  end


  # TODO: Copy a valid ID for a contact here
  contact_id = 'conid'


  def test_GET_me_contacts
    # Maximum 30 results per page.
    view_size = 30
    # Set the page from the query parameter.
    page = 1
    # Only retrieve display name.
    fields = ["DisplayName"]
    # Sort by display name
    sort = { :sort_field => 'DisplayName', :sort_order => 'ASC' }
    contacts = @outlook_client.get_contacts @token, view_size, page, fields, sort          
    assert @test_response, contacts
  end

  def test_GET_me_contacts_id
    contact_id = 'conid'
    contact = @outlook_client.get_contact_by_id @token, contact_id
    assert @test_response, contact
  end

  def test_POST_me_contacts
      new_contact_payload = '{
    "GivenName": "Pavel",
    "Surname": "Bansky",
    "EmailAddresses": [
      {
        "Address": "pavelb@a830edad9050849NDA1.onmicrosoft.com",
        "Name": "Pavel Bansky"
      }
    ],
    "BusinessPhones": [
      "+1 732 555 0102"
    ]
  }'
    new_contact_json = JSON.parse(new_contact_payload)
    new_contact = @outlook_client.create_contact @token, new_contact_json
    assert @test_response, new_contact
  end

  def test_PATCH_me_contacts_id
    new_contact = {'Id' => 'conid'}
    update_contact_payload = '{
    "HomeAddress": {
      "Street": "Some street",
      "City": "Seattle",
      "State": "WA",
      "PostalCode": "98121"
    },
    "Birthday": "1974-07-22"
  }'
    update_contact_json = JSON.parse(update_contact_payload)
    updated_contact = @outlook_client.update_contact @token, update_contact_json, new_contact['Id']
    assert @test_response, updated_contact
  end

  def test_DELETE_me_contacts_id
    new_contact = {'Id' => 'conid'}
    delete_response = @outlook_client.delete_contact @token, new_contact['Id']
    assert @test_response, delete_response
  end

end
