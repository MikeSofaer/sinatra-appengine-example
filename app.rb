require 'rubygems'
require 'sinatra'
require 'lib/waveapi/init'
require 'appengine-apis/logger'
 
get '/' do
  "I AM WAVE ROBOT! I sing like Frank on JRuby!"
end

get '/_wave/capabilities.xml' do
    content_type 'text/xml'
    robot.capabilities
end

post '/_wave/robot/jsonrpc' do
  logger.info "request " << request.to_s
  logger.info "request body " << request.body.to_s
  logger.info "request body class " << request.body.class.name
  logger.info "request env " << request.env.to_s
  logger.info "request env keys " << request.env.keys.join(' .. ').to_s
  logger.info "request rack input " << request.env["rack.input"].to_s
  logger.info "request rack request " << request.env["rack.request"].to_s
  logger.info "request rack request post " << request.env["rack.request"].POST.to_s
  logger.info "request rack request post class" << request.env["rack.request"].POST.class.name
  logger.info "request rack request form input" << request.env["rack.request.form_input"].read.to_s
  logger.info "request rack request form hash" << request.env["rack.request.form_hash"].to_s
  logger.info "request rack request form hash keys" << request.env["rack.request.form_hash"].keys.join(' .. ').to_s
  logger.info "request rack request query string" << request.env["rack.request.query_string"].to_s
  logger.info "request rack servlet request" << request.env["java.servlet_request"].to_s
  logger.info "request rack servlet input stream" << request.env["java.servlet_request"].getInput.to_s
    logger.info "request rack servlet input stream value " << request.env["java.servlet_request"].getInput.read.to_s
	logger.info "Recreate json? " << request.env["rack.request"].POST.to_json
  
  raw = request.env["rack.input"].read
  logger.info "raw " << raw.to_s
  logger.info "Request params " << params.to_s
  logger.info "Params class " << params.class.name
  logger.info "Request param keys" << params.keys.map{|k| k.to_s}.join("  ...  ")
  logger.info "Command not yet found"
  logger.info "craziness " << JSON(request.env["rack.request"].POST)
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