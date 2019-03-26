
require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class BaseCommand < Hanami::CLI::Commands::Command
          def self.inherited(child)
            super
            child.class_eval do
              argument :config, desc: "Config overrides"
            end
          end

          def call(config: '', **)
            #hack, because we can't load before hanami cli
            #more: https://github.com/hanami/hanami/issues/960
            Webpack.load_app_config
            override_config(config) if config.length > 0
          end

          private def override_config(config)
            overrides = config.split(/\s+/).map {|c| c.split(?=) }.to_h
            return if overrides.count == 0

            Webpack.configure do |configuration|
              overrides.each do |key, value|
                *sub_keys, last_key = key.split('.')
                current_config = configuration
                sub_keys.each do |k|
                  current_config = current_config.send(k)
                end
                current_config.send((last_key + ?=).to_sym, value)
              end
            end
          end
        end
      end
    end
  end
end