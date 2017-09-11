require_relative 'webpack/view_helper'
require_relative 'webpack/dev_server'
require_relative 'webpack/security_headers_hijack'
require 'dry/configurable'

module Hanami
  module Webpack
    extend Dry::Configurable

    setting :manifest_file, 'webpack_manifest.json'
    setting :public_path, 'public/dist'
    setting :dev_server do
      setting :port, '3020'
      setting :host, 'localhost'
      setting :using?, :default do |value|
        if value == :default
          Hanami.env == 'development'
        else
          value
        end
      end
    end
  end
end