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
    setting :envs_prefix, 'HANAMI_WEBPACK'
    setting :custom_envs, {}
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
        env: Hanami.env,
        stage: config.stage || Hanami.env,
        root: Hanami.root,
        dev_server_port: config.dev_server.port,
        dev_server_host: config.dev_server.host,
        dev_server_https: config.dev_server.https,
        dev_server_hot: config.dev_server.hot,
        dev_server_cert_dir: config.dev_server.cert_dir,
        dev_server_cert_name: config.dev_server.cert_name,
        dev_server_using: Webpack.use_dev_server?,
        manifest_dir: absolute_path(config.manifest.dir),
        manifest_filename: config.manifest.filename,
        output_path: webpack_output_path,
        web_path: web_path,
      }

      config.custom_envs.each do |k, v|
        envs["custom_#{k}".to_sym] = v
      end

      named_envs = envs.map do |k, v|
        key = "#{config.envs_prefix}_#{k.upcase}"
        [key, v]
      end.to_h

      shellescape_hash(named_envs)
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
