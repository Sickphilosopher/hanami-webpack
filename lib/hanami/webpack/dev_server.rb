module Hanami
  module Webpack
    module DevServer
      def start
        spawn 'bin/hanami', 'webpack', 'server' if Webpack.config.dev_server.using?
        super
      end
    end
  end
end
