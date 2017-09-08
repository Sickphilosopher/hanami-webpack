require 'hanami/utils/blank'
require_relative 'manifest'

module Hanami
  module Webpack
    module ViewHelper
      def webpack_asset_path(bundle_name)
        return raw('') if bundle_name.strip.empty?
        raw(Hanami::Webpack::Manifest.bundle_uri(bundle_name))
      end
    end
  end
end
