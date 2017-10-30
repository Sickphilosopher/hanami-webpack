require 'net/http'
require 'hanami/utils/blank'
require 'hanami/utils/path_prefix'
require_relative 'errors/manifest_not_found_error'
require_relative 'errors/entry_point_missing_error'

module Hanami
  module Webpack
    class Manifest
      def self.bundle_uri(bundle_name, type: :js)
        bundle = get_bundle(bundle_name)
        path = bundle.fetch(type.to_s)
        build_path(path)
      end

      def self.build_path(path)
        if Webpack.config.dev_server.using?
          return "#{dev_server_path}#{Utils::PathPrefix.new('/').join(path)}"
        end

        Utils::PathPrefix.new('/').join(Webpack.config.output_path).join(path).to_s
      end

      def self.get_bundle(bundle_name)
        manifest.fetch(bundle_name) do
          raise Webpack::EntryPointMissingError, "Can't find entry point '#{bundle_name}' in webpack manifest"
        end
      end

      def self.static_manifest
        File.read(static_manifest_path)
      rescue Errno::ENOENT => e
        raise Webpack::Errors::ManifestNotFoundError.new(static_manifest_path)
      end

      def self.manifest
        @_manifest = nil unless Webpack.config.cache_manifest?
        @_manifest ||= Hanami::Utils::Json.parse(static_manifest)
      end

      def self.static_manifest_path
        Hanami.root.join(Webpack.config.manifest.dir, Webpack.config.manifest.filename)
      end

      def self.dev_server_path
        "//#{Webpack.config.dev_server.host}:#{Webpack.config.dev_server.port}"
      end
    end
  end
end
