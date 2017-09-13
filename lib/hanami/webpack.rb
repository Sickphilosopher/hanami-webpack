require 'dry/configurable'

module Hanami
  module Webpack
    extend Dry::Configurable

    setting :manifest_dir, '.webpack'
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

    def self.enviroment_variables
      envs = {
        "HANAMI_WEBPACK_ENV" => Hanami.env,
        "HANAMI_WEBPACK_DEV_SERVER_PORT" => Webpack.config.dev_server.port,
        "HANAMI_WEBPACK_DEV_SERVER_HOST" => Webpack.config.dev_server.host,
        "HANAMI_WEBPACK_DEV_SERVER_USING" => Webpack.config.dev_server.using?,
        "HANAMI_WEBPACK_MANIFEST_PATH" => Webpack::Manifest.static_manifest_path,
        "HANAMI_WEBPACK_PUBLIC_PATH" => Webpack.config.public_path
      }
      shellescape_hash(envs)
    end

    private
    def self.shellescape_hash(hash)
      Hash[hash.map{ |key, value| [key, Shellwords.escape(value)] }]
    end
  end
end