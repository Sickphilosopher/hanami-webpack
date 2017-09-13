module Hanami
  module Webpack
    module DevServer
      def start
        if Hanami::Webpack.config.dev_server.using?
          spawn Hanami::Webpack.enviroment_variables, './node_modules/.bin/webpack-dev-server'
        end
        super
      end
    end
  end
end
