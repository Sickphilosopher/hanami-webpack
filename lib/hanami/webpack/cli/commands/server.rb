
require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class Server < Hanami::CLI::Commands::Command
          requires 'finalizers'
          desc 'Start Webpack dev server'

          def call(*)
            exec Webpack.enviroment_variables, './node_modules/.bin/webpack-dev-server', *Webpack.webpack_cli_arguments
          end
        end
      end
    end
  end
end
