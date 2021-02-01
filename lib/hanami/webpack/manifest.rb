require 'net/http'
require 'hanami/utils/blank'
require 'hanami/utils/path_prefix'
require_relative 'errors/manifest_not_found_error'
require_relative 'errors/entry_point_missing_error'

module Hanami
  module Webpack
    class Manifest
      def self.bundle_uri(bundle_name, type: :js, app: null)
        bundle = get_bundle(bundle_name, app)
        path = bundle.fetch(type.to_s)
        build_path(path, app)
      end

      def self.build_path(path, app)
        if Webpack.use_dev_server?
          return "#{dev_server_path(app)}#{Utils::PathPrefix.new('/').join(path)}"
        end

        Utils::PathPrefix.new('/').join(Webpack.config.output_path).join(path).to_s
      end

      def self.get_bundle(bundle_name, app)
        manifest(app).fetch(bundle_name) do
          raise Errors::EntryPointMissingError, "Can't find entry point '#{bundle_name}' in webpack manifest"
        end
      end

      def self.static_manifest(app)
        File.read(static_manifest_path(app))
      rescue Errno::ENOENT => e
        raise Webpack::Errors::ManifestNotFoundError.new(static_manifest_path(app))
      end

      def self.manifest(app)
        @_manifests = nil unless Webpack.config.manifest.cache
        @_manifests ||= {}
        @_manifests[app || :main] ||= Hanami::Utils::Json.parse(static_manifest(app))
      end

      def self.static_manifest_path(app)
        filename = Webpack.config.manifest.filename
        filename = filename.gsub('[app]', app.to_s) if app
        Hanami.root.join(Webpack.config.manifest.dir, filename)
      end

      def self.dev_server_path(app)
        port = Webpack.config.dev_server.ports[app]
        "//#{Webpack.config.dev_server.host}:#{port}"
      end
    end
  end
end
