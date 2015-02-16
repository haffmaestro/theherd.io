module Todoist

  @connection = Faraday.new(:url => 'http://todoist.com') do |faraday|
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.adapter  Faraday.default_adapter
  end

  def self.login(email, password)
    response = @connection.post '/API/login', {email: email, password: password}
    if response.status == 200
      return JSON.parse(response.body)
    else
      return false
    end
  end

  def self.new_item(user, item, due_date=nil)
    # date string can be +(number of days) so +7 will give a week
    if due_date
      response = @connection.post '/API/addItem', {token: user.todoist_api_token, content: item, date_string: due_date}
    else
      response = @connection.post '/API/addItem', {token: user.todoist_api_token, content: item}
    end
    if response.status == 200
      return JSON.parse(response.body)
    else
      return false
    end
  end
end