require 'hanami/commands/command'
require 'hanami/webpack'

module Hanami
  module Webpack
    class Commands
      class DevServer < Hanami::Commands::Command
        #require all, because hanami must load initializers from project
        requires 'all'

        def start
          spawn Webpack.enviroment_variables, './node_modules/.bin/webpack-dev-server', *Webpack.webpack_cli_arguments
        end
      end
    end
  end
end