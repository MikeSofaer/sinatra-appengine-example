require 'rubygems'
require 'sinatra'
require 'lib/waveapi/init'
require 'appengine-apis/logger'
require 'lib/json'
require 'json'
import org.json.JSONObject
 
get '/' do
  "I AM WAVE ROBOT! I sing like Frank on JRuby!"
end

get '/_wave/capabilities.xml' do
    content_type 'text/xml'
    robot.capabilities
end

post '/_wave/robot/jsonrpc' do
  json = JSONObject.new(params.to_json)
  logger.info "parsed? " << Robot.ParseJSONBody(json).to_s
  robot.run_rpc(params)
end

post '/_wave/robot/:command' do
  begin
    logger.info(params)
    robot.run_command(params[:command], params)
  rescue => e
    e.message << "\n" << e.backtrace.join("\n")
  end
end

def robot
  Robot.from_yml('robot.yml')  
end

def logger
  AppEngine::Logger.new
end