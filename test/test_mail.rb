require 'helper'

class MailTest < Minitest::Test

  def setup
    # TODO: Copy a valid, non-expired access token here.
    @token = 'eyJ0eXAiOiJKV1QiLCJhbGciO...' # access_ token
  end

  def test_should_GET_me_messages

      faraday_instance = Faraday.new() do |faraday|
        stubs = Faraday::Adapter::Test::Stubs.new
         faraday.adapter :test, stubs do |stub|
          stub.get('/api/v1.0/Me/Messages') { |env| [200, {}, {'body'=>'ok'}.to_json ] }
        end

        # faraday.adapter :test, stubs do |stub|
        #   stub.get('/api/v1.0/Me/Messages') { |env| [200, {}, {'body'=>'ok'}.to_json ] }
        # end
      end
    # Maximum 30 results per page.
    view_size = 30
    # Set the page from the query parameter.
    page = 1
    # Only retrieve display name.
    fields = [
      "Subject"
    ]
    # Sort by display name
    sort = { :sort_field => 'Subject', :sort_order => 'ASC' }
    outlook_client = O365::Client.new faraday_instance: faraday_instance
    outlook_client.test = true
    
    messages = outlook_client.get_messages @token,
              view_size, page, fields, sort        
    puts messages
  end

#   def test_should_GET_me_messages_id
#     # TODO: Copy a valid ID for a message here
#     message_id = 'AAMkADNhMjcxM2U5LWY2MmItNDRjYy05YzgwLWQwY2FmMTU1MjViOABGAAAAAAC_IsPnAGUWR4fYhDeYtiNFBwCDgDrpyW-uTL4a3VuSIF6OAAAAAAEMAACDgDrpyW-uTL4a3VuSIF6OAAAZHKJNAAA='
#     outlook_client = O365::Client.new
#     message = outlook_client.get_message_by_id @token, message_id
#     puts message
#   end

#   def test_should_POST_me_messages
#     new_message_payload = '{
#         "Subject": "Did you see last night\'s game?",
#         "Importance": "Low",
#         "Body": {
#           "ContentType": "HTML",
#           "Content": "They were <b>awesome</b>!"
#         },
#         "ToRecipients": [
#           {
#             "EmailAddress": {
#               "Address": "katiej@a830edad9050849NDA1.onmicrosoft.com"
#             }
#           }
#         ]
#       }'
#     new_message_json = JSON.parse(new_message_payload)
#     outlook_client = O365::Client.new
#     new_message = outlook_client.create_message @token, new_message_json
#     puts new_message
#   end

#   def test_should_PATCH_me_messages_id
#           update_message_payload = '{
#         "Subject": "UPDATED"
#       }'
#   update_message_json = JSON.parse(update_message_payload)
#   outlook_client = O365::Client.new
#   updated_message = outlook_client.update_message @token, update_message_json, new_message['Id']

#     puts updated_message
#   end

#   def test_should_DELETE_me_messages_id
#   delete_response = @outlook_client.delete_message @token, new_message['Id']
#   outlook_client = O365::Client.new
#   puts delete_response.nil? ? "SUCCESS" : delete_response
#   end
  
#   def test_should_POST_me_sendmail
#         send_message_payload = '{
#       "Subject": "Meet for lunch?",
#       "Body": {
#         "ContentType": "Text",
#         "Content": "The new cafeteria is open."
#       },
#       "ToRecipients": [
#         {
#           "EmailAddress": {
#             "Address": "allieb@contoso.com"
#           }
#         }
#       ],
#       "Attachments": [
#         {
#           "@odata.type": "#Microsoft.OutlookServices.FileAttachment",
#           "Name": "menu.txt",
#           "ContentBytes": "bWFjIGFuZCBjaGVlc2UgdG9kYXk="
#         }
#       ]
#     }'
#   send_message_json = JSON.parse(send_message_payload)
#   outlook_client = O365::Client.new
#   send_response = outlook_client.send_message @token, send_message_json
  
#   puts send_response.nil? ? "SUCCESS" : send_response
#   end
end
