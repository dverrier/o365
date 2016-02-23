require 'helper'

class CalendarTest < Minitest::Test
  def setup
    # TODO: Copy a valid, non-expired access token here.
    @token = 'eyJ0eXAiOiJKV1QiLCJhbGciO...' # access_ token

    @test_response = {'body'=>'ok'}
    faraday_instance = Faraday.new() do |faraday|
      stubs = Faraday::Adapter::Test::Stubs.new
      faraday.adapter :test, stubs do |stub|
        stub.get('/api/v1.0/Me/CalendarView') { |env| [200, {}, @test_response.to_json ] }
        stub.get('/api/v1.0/Me/Events') { |env| [200, {}, @test_response.to_json ] }
        stub.get('/api/v1.0/Me/Events/eventid') { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/Events") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.patch("/api/v1.0/Me/Events/eventid") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
        stub.delete("/api/v1.0/Me/Events/eventid") { |env| [200, {}, @test_response.to_json ] }
        stub.post("/api/v1.0/Me/SendMail") { |env| [200, {'Content-Type' => 'application/json'}, @test_response.to_json ] }
      end
    end
    @outlook_client = O365::Client.new faraday_instance: faraday_instance
  end

  # TODO: Copy a valid ID for an event here
  event_id = 'AAMkADNhMjcxM2U5LWY2MmItNDRjYy05YzgwLWQwY2FmMTU1MjViOABGAAAAAAC_IsPnAGUWR4fYhDeYtiNFBwCDgDrpyW-uTL4a3VuSIF6OAAAAAAENAACDgDrpyW-uTL4a3VuSIF6OAAAXZ15oAAA='

  def test_GET_me_CalendarView
    start_time = DateTime.parse('2015-03-03T00:00:00Z')
    end_time = DateTime.parse('2015-03-10T00:00:00Z')
    view = @outlook_client.get_calendar_view @token, start_time, end_time          
    assert @test_response, view
  end
  
  
  def test_GET_me_events
    # Maximum 30 results per page.
    view_size = 30
    # Set the page from the query parameter.
    page = 1
    # Only retrieve display name.
    fields = ["Subject"]
    # Sort by display name
    sort = { :sort_field => 'Subject', :sort_order => 'ASC' }
    events = @outlook_client.get_events @token, view_size, page, fields, sort          
    assert @test_response, events
  end

  def test_GET_me_events_id
    event_id = 'eventid'
    event = @outlook_client.get_event_by_id @token, event_id
    assert @test_response, event
  end

  def test_POST_me_events
    new_event_payload = '{
      "Subject": "Discuss the Calendar REST API",
      "Body": { "ContentType": "HTML",
        "Content": "I think it will meet our requirements!" },
      "Start": "2014-07-02T18:00:00Z",
      "End": "2014-07-02T19:00:00Z",
      "Attendees": [
      { "EmailAddress": { "Address": "janets@a830edad9050849NDA1.onmicrosoft.com",
                          "Name": "Janet Schorr" },
      "Type": "Required" }
      ]
    }'
    new_event_json = JSON.parse(new_event_payload)
    new_event = @outlook_client.create_event @token, new_event_json
    assert @test_response, new_event
  end

  def test_PATCH_me_events_id
    new_event = {'Id' => 'eventid'}
    update_event_payload = '{
      "Location": { "DisplayName": "Your office" }
    }'
    update_event_json = JSON.parse(update_event_payload)
    updated_event = @outlook_client.update_event @token, update_event_json, new_event['Id']
    assert @test_response, updated_event
  end

  def test_DELETE_me_events_id
    new_event = {'Id' => 'eventid'}
    delete_response = @outlook_client.delete_event @token, new_event['Id']
    assert @test_response, delete_response.nil? ? "SUCCESS" : delete_response
  end
end 

