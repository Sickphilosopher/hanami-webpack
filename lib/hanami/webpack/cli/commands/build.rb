
require_relative 'base_command'

module Hanami
  module Webpack
    module Cli
      module Commands
        class Build < BaseCommand
          WEBPACK_EXECUTABLES = %w(parallel-webpack webpack)
          desc 'Build Webpack bundles'

          def call(config: '', **)
            super
            exec Webpack.enviroment_variables, webpack_exe, *Webpack.webpack_cli_arguments
          end

          private def webpack_exe
            executable = WEBPACK_EXECUTABLES
              .lazy
              .map { |e| node_modules_exe_path(e) }
              .find { |e| File.exists?(e) }
          end

          private def node_modules_exe_path(exe_name)
            "./node_modules/.bin/#{exe_name}"
          end
        end
      end
    end
  end
end
