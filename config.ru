require File.expand_path('../config/environment', __FILE__)

use RackMojAuth::ProxyMiddleware

run Opg::App.instance

