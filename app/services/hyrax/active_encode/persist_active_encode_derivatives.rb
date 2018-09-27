# frozen_string_literal: true

module Hyrax
  module ActiveEncode
    class PersistActiveEncodeDerivatives
      # @param [ActiveEncode::Output] output the output from the active_encode adapter
      # @param [Hash] directives directions which can be used to determine where to persist to.
      # @option directives [String] derivative_directory if present the directory to copy the derivative
      # @option directives [String] file_set_id the id of the file set to add the derivative
      def self.call(output, directives)
        file_set = ActiveFedora::Base.find(directives[:file_set_id])
        if directives[:derivative_directory].present?
          new_url = move_derivative(output, directives)
          output.url = Hyrax::Engine.routes.url_helpers.download_path(file_set, file: File.basename(new_url))
        end
        create_pcdm_file(output, file_set, directives)
      end

      def self.create_pcdm_file(output, file_set, _directives)
        pcdm_file = file_set.build_derivative
        pcdm_file.label = output.label
        pcdm_file.external_file_uri = output.url
        pcdm_file.content = ''
        file_set.save!
      end
      private_class_method :create_pcdm_file

      def self.move_derivative(output, directives)
        output_uri = URI(output.url)
        move_dir = File.absolute_path(directives[:derivative_directory])
        file_path = File.join(move_dir, File.basename(output_uri.path))
        FileUtils.mkdir_p move_dir
        if output_uri.scheme == "file"
          FileUtils.mv output_uri.path, file_path
        else
          # Read from remote url and persist to derivative_path
          open(output_uri) { |io| IO.copy_stream(io, File.open(file_path, 'wb')) }
        end
        "file://" + file_path
      end
      private_class_method :move_derivative
    end
  end
end
