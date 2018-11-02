module Hanami
  module Webpack
    module DevServer
      def start
        start_server = Hanami::Webpack.config.dev_server.using
        spawn 'bin/hanami', 'webpack', 'server' if start_server
        super
      end
    end
  end
end
