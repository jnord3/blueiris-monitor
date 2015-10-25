require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  host = ENV['host']
  user = ENV['user']
  password = ENV['password']
  cameras = ENV['cameras']
  result = system("ruby monitor.rb --host #{host}  --user #{user} --password #{password} --cameras #{cameras}")
  if result
    status 200 
  else
    status 500 
  end 
end
