require 'net/http'
require 'json'
require 'digest/md5'
require 'trollop'


def make_call(url,payload)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 360
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = payload.to_json
  http.request(request).body
end

# setup options
opts = Trollop::options do
  opt :host, "host of blue iris", :type => :string  
  opt :user, "Blue iris user", :type => :string  
  opt :password, "Blue iris user password", :type => :string 
  opt :cameras, "Cameras to validate", :type => :strings
end

Trollop::die :host, "Must specify a host" unless opts[:host]
Trollop::die :user, "Must specify a user" unless opts[:user]
Trollop::die :password, "Must specify a password" unless opts[:password]
Trollop::die :cameras, "Must specify a list of cameras" unless opts[:cameras]

get_session_payload = {
 "cmd" => "login"
}
url = "http://#{opts[:host]}:81/json"
get_session_response = JSON.parse(make_call(url, get_session_payload))

digest = Digest::MD5.hexdigest("#{opts[:user]}:#{get_session_response["session"]}:#{opts[:password]}")

login_payload = {
  "cmd" => "login",
  "session" => get_session_response["session"],
  "response" => digest
}

login_result = JSON.parse(make_call(url, login_payload))
if login_result["result"] != "success" 
  puts "unable to login - failing"
  exit 1
end

camlist_payload = {
  "cmd" => "camlist",
  "session" => login_result["session"]
}

camlist_result = JSON.parse(make_call(url, camlist_payload))

if camlist_result["result"] != "success"
  puts "error when trying to get camlist_result. Value was:"
  puts camlist_result
  exit 1
end

camlist_recording = 0
camlist_result["data"].each do |data_item|
  if opts[:cameras].include?(data_item["optionValue"])
    if data_item["isRecording"] != true
      puts "#{data_item["optionDisplay"]} is not recording!"
      exit 1
    else 
      camlist_recording += 1
    end
  end
end

if camlist_recording != opts[:cameras].length
  puts "only found #{camlist_recording} cameras recording"
  exit 1
end
puts "success"
exit 0
