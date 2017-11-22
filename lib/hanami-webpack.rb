require 'hanami/server'
require 'hanami/view'
require 'hanami/utils/blank'
require 'hanami/config/security'
require_relative 'hanami/webpack'
require_relative 'hanami/webpack/view_helper'
require_relative 'hanami/webpack/dev_server'
require_relative 'hanami/webpack/security_headers_hijack'

#commands for cli
require_relative 'hanami/webpack/cli/commands/version'
require_relative 'hanami/webpack/cli/commands/build'
require_relative 'hanami/webpack/cli/commands/server'

Hanami::Config::Security.prepend(Hanami::Webpack::SecurityHeadersHijack)
Hanami::Server.prepend(Hanami::Webpack::DevServer)
Hanami::View.prepend(Hanami::Webpack::ViewHelper)