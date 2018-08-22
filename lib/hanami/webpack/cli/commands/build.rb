
require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class Build < Hanami::CLI::Commands::Command
          WEBPACK_EXECUTABLES = %w(parallel-webpack webpack)
          requires 'finalizers'
          desc 'Build Webpack bundles'
          argument :config, desc: "Config overrides"

          def call(config: '', **)
            override_config(config) if config.length > 0
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

          private def override_config(config)
            overrides = config.split(/\s+/).map {|c| c.split(?=) }.to_h
            return if overrides.count == 0

            Webpack.configure do |configuration|
              overrides.each do |key, value|
                configuration.send((key + ?=).to_sym, value)
              end
            end
          end
        end
      end
    end
  end
end

Hanami::CLI.register "webpack build", Hanami::Webpack::Cli::Commands::Build