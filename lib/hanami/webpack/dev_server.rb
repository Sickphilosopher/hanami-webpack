module Hanami
  module Webpack
    module DevServer
      def start
        #hack, because we can't load before hanami cli
        #more: https://github.com/hanami/hanami/issues/960
        Webpack.load_app_config

        start_server = Hanami::Webpack.use_dev_server? && Hanami::Webpack.config.dev_server.auto_start
        spawn 'bin/hanami', 'webpack', 'server' if start_server
        super
      end
    end
  end
end