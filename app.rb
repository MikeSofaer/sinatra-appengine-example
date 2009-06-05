require 'rubygems'
require 'sinatra'
require 'lib/waveapi/init'
 
get '/' do
  "Hello from Sinatra running on Java!"
end

get '/_wave/capabilities.xml' do
  begin
    robot.capabilities.to_s
  rescue
    $!
  end
end

get '/_wave/robot/:command' do
  robot.run_command(params[:command])
end

get '/ping' do
  robot.to_s
end

def robot
  Robot.new('Bob')
end