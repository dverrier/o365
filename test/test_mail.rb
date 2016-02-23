require 'helper'

class MailTest < Minitest::Test

  def setup
    # TODO: Copy a valid, non-expired access token here.
    @token = 'eyJ0eXAiOiJKV1QiLCJhbGciO...' # access_ token

    # @new_message_payload = {"msg"=> "text"}.to_json
    @test_response = {'body'=>'ok'}
    faraday_instance = Faraday.new() do |faraday|
      stubs = Faraday::Adapter::Test::Stubs.new
      faraday.adapter :test, stubs do |stub|
        stub.get('/api/v1.0/Me/Messages') { |env| [200, {}, @test_response.to_json ] }
        stub.get('/api/v1.0/Me/Messages/msgid') { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/Messages") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.patch("/api/v1.0/Me/Messages/msgid") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.delete("/api/v1.0/Me/Messages/msgid") { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/SendMail") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
      end
    end
    @outlook_client = O365::Client.new faraday_instance: faraday_instance
  end

  def test_should_GET_me_messages
    # Maximum 30 results per page.
    view_size = 30
    # Set the page from the query parameter.
    page = 1
    # Only retrieve display name.
    fields = ["Subject"]
    # Sort by display name
    sort = { :sort_field => 'Subject', :sort_order => 'ASC' }
    
    messages = @outlook_client.get_messages @token, view_size, page, fields, sort        
    assert @test_response, messages
  end

  def test_should_GET_me_messages_id
    message_id = 'msgid'
    message = @outlook_client.get_message_by_id @token, message_id
    assert @test_response, message
  end

  def test_should_POST_me_messages
    @new_message_payload = '{
      "Subject": "Did you see last night\'s game?",
      "Importance": "Low",
      "Body": {
          "ContentType": "HTML",
          "Content": "They were <b>awesome</b>!"
      },
      "ToRecipients": [
        {
          "EmailAddress": {
            "Address": "katiej@a830edad9050849NDA1.onmicrosoft.com"
          }
        }
      ]
    }'
    new_message_json = JSON.parse(@new_message_payload)
    new_message = @outlook_client.create_message @token, new_message_json
    assert @test_response, new_message
  end

  def test_should_PATCH_me_messages_id
    update_message_payload = '{
        "Subject": "UPDATED"
      }'
    old_message= {'Id'=> 'msgid'}
    update_message_json = JSON.parse(update_message_payload)
    updated_message = @outlook_client.update_message @token, update_message_json, old_message['Id']
    assert @test_response, updated_message
  end

  def test_should_DELETE_me_messages_id
    message= {'Id'=> 'msgid'}
    delete_response = @outlook_client.delete_message @token, message['Id']
    assert @test_response, delete_response
  end
  
  def test_should_POST_me_sendmail
    send_message_payload = '{
      "Subject": "Meet for lunch?",
      "Body": {
        "ContentType": "Text",
        "Content": "The new cafeteria is open."
      },
      "ToRecipients": [
        {
          "EmailAddress": {
            "Address": "allieb@contoso.com"
          }
        }
      ],
      "Attachments": [
        {
          "@odata.type": "#Microsoft.OutlookServices.FileAttachment",
          "Name": "menu.txt",
          "ContentBytes": "bWFjIGFuZCBjaGVlc2UgdG9kYXk="
        }
      ]
    }'
    send_message_json = JSON.parse(send_message_payload)
    send_response = @outlook_client.send_message @token, send_message_json
    assert @test_response, send_response
  end
end
