require 'dry/configurable'

module Hanami
  module Webpack
    extend Dry::Configurable

    if Hanami.env == 'development'
      using_dev_server_default = true
      cache_manifest_default = false
    else
      using_dev_server_default = false
      cache_manifest_default = true
    end

    setting :manifest do
      setting :dir, '.webpack'
      setting :filename, 'webpack-assets.json'
    end

    setting :public_path, 'public'
    setting :output_path, 'dist'
    setting :cache_manifest?, cache_manifest_default
    setting :dev_server do
      setting :port, '3020'
      setting :host, 'localhost'
      setting :using?, using_dev_server_default
    end

    def self.enviroment_variables
      envs = {
        "HANAMI_WEBPACK_ENV" => Hanami.env,
        "HANAMI_WEBPACK_DEV_SERVER_PORT" => Webpack.config.dev_server.port,
        "HANAMI_WEBPACK_DEV_SERVER_HOST" => Webpack.config.dev_server.host,
        "HANAMI_WEBPACK_DEV_SERVER_USING" => Webpack.config.dev_server.using?,
        "HANAMI_WEBPACK_MANIFEST_DIR" => Webpack.config.manifest.dir,
        "HANAMI_WEBPACK_MANIFEST_FILENAME" => Webpack.config.manifest.filename,
        "HANAMI_WEBPACK_OUTPUT_PATH" => webpack_output_path
      }
      shellescape_hash(envs)
    end

    private
    def self.shellescape_hash(hash)
      Hash[hash.map{ |key, value| [key, Shellwords.escape(value)] }]
    end

    def self.webpack_output_path
      Utils::PathPrefix.new('/').join(Webpack.config.public_path).join(Webpack.config.output_path)
    end
  end
end