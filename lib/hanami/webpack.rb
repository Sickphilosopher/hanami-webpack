require 'dry/configurable'

module Hanami
  module Webpack
    extend Dry::Configurable

    setting :manifest do
      setting :dir, '.webpack'
      setting :filename, 'webpack-assets.json'
      setting :cache, true
    end

    setting :public_path, 'public' #relative to Hanami.root
    setting :output_path, 'dist' #relative to public_path
    setting :webpack_config_path, 'webpack.config.js' #relative to Hanami.root
    setting :stage, nil
    setting :dev_server do
      setting :port, 3020
      setting :host, 'localhost'
      setting :using, :auto
      setting :auto_start, true
      setting :https, false
      setting :cert_dir, ''
      setting :cert_name, ''
      setting :hot, true
    end

    def self.enviroment_variables
      envs = {
        "HANAMI_WEBPACK_ENV" => Hanami.env,
        "HANAMI_WEBPACK_STAGE" => config.stage || Hanami.env,
        "HANAMI_WEBPACK_ROOT" => Hanami.root,
        "HANAMI_WEBPACK_DEV_SERVER_PORT" => config.dev_server.port,
        "HANAMI_WEBPACK_DEV_SERVER_HOST" => config.dev_server.host,
        "HANAMI_WEBPACK_DEV_SERVER_HTTPS" => config.dev_server.https,
        "HANAMI_WEBPACK_DEV_SERVER_HOT" => config.dev_server.hot,
        "HANAMI_WEBPACK_DEV_SERVER_CERT_DIR" => config.dev_server.cert_dir,
        "HANAMI_WEBPACK_DEV_SERVER_CERT_NAME" => config.dev_server.cert_name,
        "HANAMI_WEBPACK_DEV_SERVER_USING" => Webpack.use_dev_server?,
        "HANAMI_WEBPACK_MANIFEST_DIR" => absolute_path(config.manifest.dir),
        "HANAMI_WEBPACK_MANIFEST_FILENAME" => config.manifest.filename,
        "HANAMI_WEBPACK_OUTPUT_PATH" => webpack_output_path,
        "HANAMI_WEBPACK_WEB_PATH" => web_path
      }
      shellescape_hash(envs)
    end

    def self.webpack_cli_arguments
      absolute_webpack_config_path = Hanami.root.join(config.webpack_config_path)
      arguments = ['--config', absolute_webpack_config_path.to_s]
      arguments
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

    def self.web_path
      Utils::PathPrefix.new('/').join(config.output_path, '')
    end

    def self.load_app_config
      require Hanami.root.join('config', 'initializers', 'webpack')
    end

    def self.use_dev_server?
      return true if Webpack.config.dev_server.using
      return true if Webpack.config.dev_server.using == :auto && Hanami.env?(:development)
      return false
    end
  end
end
