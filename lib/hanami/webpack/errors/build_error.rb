module Hanami
  module Webpack
    module Errors
      class BuildError < StandardError
        def initialize(errors)
          super "Error in webpack compile, details follow below:\n#{errors.join("\n\n")}"
        end
      end
    end
  end
end
