require 'hanami/webpack/commands/dev_server'
module Hanami
  module Webpack
    module DevServer
      def start
        Webpack::Commands::DevServer.new({}).start if Webpack.config.dev_server.using?
        super
      end
    end
  end
end
