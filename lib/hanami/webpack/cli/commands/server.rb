
require_relative 'base_command'

module Hanami
  module Webpack
    module Cli
      module Commands
        class Server < BaseCommand
          desc 'Start Webpack dev server'

          def call(*)
            super
            exec Webpack.environment_variables, "yarn", "run", "webpack", "serve", *Webpack.webpack_cli_arguments
          end
        end
      end
    end
  end
end
