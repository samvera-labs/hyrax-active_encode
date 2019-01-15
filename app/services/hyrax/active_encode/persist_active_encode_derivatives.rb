# frozen_string_literal: true

module Hyrax
  module ActiveEncode
    class PersistActiveEncodeDerivatives
      # @param [ActiveEncode::Output] output the output from the active_encode adapter
      # @param [Hash] directives directions which can be used to determine where to persist to.
      # @option directives [String] local_streaming flag for copying to Hyrax derivative directory
      # @option directives [String] file_set_id the id of the file set to add the derivative
      def self.call(output, directives)
        file_set = ActiveFedora::Base.find(directives[:file_set_id])
        file_set.encode_global_id ||= directives[:encode_global_id]
        output.url = move_derivative(output, file_set) if directives[:local_streaming]
        create_pcdm_file(output, file_set)
      end

      def self.create_pcdm_file(output, file_set)
        pcdm_file = file_set.build_derivative
        pcdm_file.label = output.label
        pcdm_file.file_location_uri = output.url
        pcdm_file.content = ''
        file_set.save!
      end
      private_class_method :create_pcdm_file

      def self.move_derivative(output, file_set)
        output_uri = URI(output.url)
        move_path = Hyrax::DerivativePath.derivative_path_for_reference(file_set.id, File.basename(output_uri.path))
        FileUtils.mkdir_p File.dirname(move_path)
        if output_uri.scheme == "file"
          FileUtils.mv output_uri.path, move_path
        else
          # Read from remote url and persist to derivative_path
          open(output_uri.to_s) { |io| IO.copy_stream(io, File.open(move_path, 'wb')) }
        end
        move_path
      end
      private_class_method :move_derivative
    end
  end
end
