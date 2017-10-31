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

    setting :public_path, 'public' #relative to Hanami.root
    setting :output_path, 'dist' #relative to public_path
    setting :cache_manifest?, cache_manifest_default
    setting :webpack_config_path, Hanami.root.join('webpack.config.js')
    setting :dev_server do
      setting :port, '3020'
      setting :host, 'localhost'
      setting :using?, using_dev_server_default
    end

    def self.enviroment_variables
      envs = {
        "HANAMI_WEBPACK_ENV" => Hanami.env,
        "HANAMI_WEBPACK_ROOT" => Hanami.root,
        "HANAMI_WEBPACK_DEV_SERVER_PORT" => config.dev_server.port,
        "HANAMI_WEBPACK_DEV_SERVER_HOST" => config.dev_server.host,
        "HANAMI_WEBPACK_DEV_SERVER_USING" => config.dev_server.using?,
        "HANAMI_WEBPACK_MANIFEST_DIR" => absolute_path(config.manifest.dir),
        "HANAMI_WEBPACK_MANIFEST_FILENAME" => config.manifest.filename,
        "HANAMI_WEBPACK_OUTPUT_PATH" => webpack_output_path,
        "HANAMI_WEBPACK_WEB_PATH" => config.output_path
      }
      shellescape_hash(envs)
    end

    def self.webpack_cli_arguments
      ['--config', config.webpack_config_path.to_s]
    end

    private
    def self.shellescape_hash(hash)
      Hash[hash.map{ |key, value| [key, Shellwords.escape(value)] }]
    end

    def self.webpack_output_path
      Hanami.root.join(config.public_path).join(config.output_path)
    end

    def self.absolute_path(path)
      Hanami.root.join(path)
    end
  end
end