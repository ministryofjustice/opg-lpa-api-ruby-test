require File.expand_path('../config/environment', __FILE__)

use RackMojAuth::ProxyMiddleware

if ENV['RACK_ENV'] == 'development'
  puts "use Clogger"
  use Clogger, :logger=> $stdout, :reentrant => true, :format => 'http_secure_token: $http_secure_token === request_uri: $request_uri'
end

run Opg::App.instance

