require_relative 'manifest'

module Hanami
  module Webpack
    module ViewHelper
      def webpack_js(bundle_name, options = {})
        path = Manifest.bundle_uri(bundle_name, type: :js, app: options.delete(:app))
        html do
          script options.merge(src: path)
        end
      end

      def webpack_css(bundle_name, options = {})
        #styles not extracted in dev environment
        return raw('') if Webpack.config.dev_server.using?
        path = Manifest.bundle_uri(bundle_name, type: :css, app: options.delete(:app))
        html do
          link options.merge(href: path, rel: 'stylesheet', type: 'text/css')
        end
      end
    end
  end
end
