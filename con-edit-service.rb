require 'rubygems'
require 'sinatra'

post '/api/v1/validate' do
  passed_items = JSON.parse(request.body.read)
  field_names = passed_items.collect {|x| x["field_name"]}
  if field_names.include?("state") && field_names.include?("zip")
    enforce_state_zip_con_edit(passed_items)
  end
end


def enforce_state_zip_con_edit(passed_items)
  response = {:status => "pass", :message => ""}
  state_item = passed_items.find {|x| x["field_name"] == "state"}
  zip_item = passed_items.find {|x| x["field_name"] == "zip"}
  if state_item["field_value"] == "CA"
    if zip_item["field_value"].to_i < 90000
      response[:status] = "fail"
      response[:message] = "this is not a valid zip code for California"
    end
  end
  response.to_json
end