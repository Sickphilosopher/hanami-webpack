require_relative 'manifest'

module Hanami
  module Webpack
    module ViewHelper
      def webpack_js(bundle_name)
        path = Manifest.bundle_uri(bundle_name, type: :js)
        javascript path
      end

      def webpack_css(bundle_name)
        #styles not extracted in dev environment
        return raw('') if Webpack.config.dev_server.using?
        path = Manifest.bundle_uri(bundle_name, type: :css)
        stylesheet path
      end
    end
  end
end
