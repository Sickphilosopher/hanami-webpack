module Hanami
  module Webpack
    module Errors
      class ManifestNotFoundError < StandardError
        def initialize(path)
          super "Cant't find manifest file with assets list on path: #{path}."
        end
      end
    end
  end
end
