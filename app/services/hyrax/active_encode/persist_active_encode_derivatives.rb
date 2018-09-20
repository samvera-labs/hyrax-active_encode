module Hyrax
  module ActiveEncode
    class PersistActiveEncodeDerivatives
      def self.call(encode, directives)
        byebug
        encode.outputs.each do |output|
          if serve_locally
            new_url = move_derivative(output, directives)
            output.url = new_url
          end
          create_pcdm_file(output, directives)
        end
      end

      # @param directives [Hash] directions which can be used to determine where to persist to.
      # @option directives [String] url URI for the parent object.
      def self.retrieve_file_set(directives)
        uri = URI(directives.fetch(:url))
        raise ArgumentError, "#{uri} is not an http(s) uri" unless uri.is_a?(URI::HTTP)
        ActiveFedora::Base.find(ActiveFedora::Base.uri_to_id(uri.to_s))
      end
      private_class_method :retrieve_file_set

      def self.create_pcdm_file(output, directives)
        file_set = retrieve_file_set(directives)
        pcdm_file = file_set.build_derivative
        pcdm_file.label = output.label
        pcdm_file.external_file_uri = output.url
        pcdm_file.save!
      end
      private_class_method :create_pcdm_file

      def self.move_derivative(output, directives)
        uri = URI(output.url)
        file_path = File.join(File.absolute_path(derivative_path), File.basename(output.url))
        if uri.file?
          FileUtils.mv output.url, file_path
        else
          # Read from remote url and persist to derivative_path
          open(output.url) { |io| IO.copy_stream(io, File.open(file_path, 'wb')) }
        end
        "file://" + file_path
      end
      private_class_method :move_derivative
    end
  end
end
