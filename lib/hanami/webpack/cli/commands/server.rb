
require_relative 'base_command'

module Hanami
  module Webpack
    module Cli
      module Commands
        class Server < BaseCommand
          desc 'Start Webpack dev server'

          def call(*)
            super
            exec Webpack.enviroment_variables, './node_modules/.bin/webpack-dev-server', *Webpack.webpack_cli_arguments
          end
        end
      end
    end
  end
end
