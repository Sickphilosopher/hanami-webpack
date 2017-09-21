require 'hanami/webpack/commands/dev_server'
module Hanami
  module Webpack
    module DevServer
      def start
        spawn 'bin/hanpack', 'dev-server' if Webpack.config.dev_server.using?
        super
      end
    end
  end
end
