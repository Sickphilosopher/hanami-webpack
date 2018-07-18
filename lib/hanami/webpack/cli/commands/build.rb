
require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class Build < Hanami::CLI::Commands::Command
          requires 'finalizers'
          desc 'Build Webpack bundles'
          WEBPACK_EXECUTABLES = %w(parallel-webpack webpack)

          def call(*)
            exec Webpack.enviroment_variables, webpack_exe, *Webpack.webpack_cli_arguments
          end

          def webpack_exe
            executable = WEBPACK_EXECUTABLES
              .map { |e| node_modules_exe_path(e) }
              .find { |e| File.exists?(e) }
          end

          def node_modules_exe_path(exe_name)
            "./node_modules/.bin/#{exe_name}"
          end
        end
      end
    end
  end
end

Hanami::CLI.register "webpack build", Hanami::Webpack::Cli::Commands::Build