require 'hanami/commands/command'
require 'hanami/webpack'

module Hanami
  module Webpack
    class Commands
      class Build < Hanami::Commands::Command
        def start
          exec Hanami::Webpack.enviroment_variables, './node_modules/.bin/webpack'
        end
      end
    end
  end
end