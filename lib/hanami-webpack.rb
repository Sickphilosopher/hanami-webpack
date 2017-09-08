require 'hanami/server'
require 'hanami/view'
require 'hanami/utils/blank'
require 'hanami/config/security'
require_relative 'hanami/webpack'

Hanami::Config::Security.prepend(Hanami::Webpack::SecurityHeadersHijack)
Hanami::Server.prepend(Hanami::Webpack::DevServer)
Hanami::View.prepend(Hanami::Webpack::ViewHelper)