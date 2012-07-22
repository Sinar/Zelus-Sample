%w(sinatra rest_client haml psych).each  { |gem| require gem}
YAML::ENGINE.yamler = "psych"

get "/" do
  page = params[:page] || 1
  page_size = params[:page_size] || 10
  response = RestClient.get "http://zelus.herokuapp.com/people/#{page_size}/#{page}"

  json = JSON.parse response
  if json['status'] == "success"
    @next_page = json['next_page']
    @previous_page = json['previous_page']
    @payload = json['payload']
    haml :index
  else
    400
  end
end

get "/:uuid" do
  response = RestClient.get "http://zelus.herokuapp.com/person/#{params[:uuid]}"
  json = JSON.parse response
  if json['status'] == "success"
    @payload = json['payload']
    haml :person
  else
    400
  end  
end