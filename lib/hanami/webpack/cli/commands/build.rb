
require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class Build < Hanami::CLI::Commands::Command
          requires 'finalizers'
          desc 'Build Webpack bundles'

          def call(*)
            exec Webpack.enviroment_variables, './node_modules/.bin/webpack', *Webpack.webpack_cli_arguments
          end
        end
      end
    end
  end
end

Hanami::CLI.register "webpack build", Hanami::Webpack::Cli::Commands::Build