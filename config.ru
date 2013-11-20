require File.expand_path('../config/environment', __FILE__)

use RackMojAuth::Middleware

run Opg::App.instance

