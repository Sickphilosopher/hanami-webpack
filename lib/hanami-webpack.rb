require 'hanami/server'
require 'hanami/view'
require 'hanami/utils/blank'
require 'hanami/config/security'
require_relative 'hanami/webpack'
require_relative 'hanami/webpack/view_helper'
require_relative 'hanami/webpack/dev_server'
require_relative 'hanami/webpack/security_headers_hijack'

#commands for cli
require_relative 'hanami/webpack/cli/commands'

Hanami::Config::Security.prepend(Hanami::Webpack::SecurityHeadersHijack)
Hanami::View.prepend(Hanami::Webpack::ViewHelper)