require 'rubygems'
require 'sinatra'
require 'lib/waveapi/init'
 
get '/' do
  "Hello from Sinatra running on Java!"
end

get '/_wave/capabilities.xml' do
  begin
    robot.capabilities
  rescue
    $!
  end
end

get '/_wave/robot/:command' do
  begin
    robot.run_command(params[:command])
  rescue => e
    e.message
  end	
end

def robot
  Robot.from_yml('robot.yml')  
end
