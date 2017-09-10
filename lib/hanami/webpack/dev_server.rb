require 'shellwords'

module Hanami
  module Webpack
    module DevServer
      def start
        if Hanami::Webpack.config.dev_server.using?
          envs = {
            "HANAMI_WEBPACK_DEV_SERVER_PORT" => Webpack.config.dev_server.port,
            "HANAMI_WEBPACK_DEV_SERVER_HOST" => Webpack.config.dev_server.host,
            "HANAMI_WEBPACK_DEV_SERVER_USING" => Webpack.config.dev_server.using?,
            "HANAMI_WEBPACK_PUBLIC_PATH" => Webpack.config.public_path.shellescape
          }
          shellescape_hash(envs)
          spawn(envs, './node_modules/.bin/webpack-dev-server')
        end
        super
      end

      private
      def shellescape_hash(hash)
        Hash[hash.map{ |key, value| [k, Shellwords.escape(value)] }]
      end
    end
  end
end
