# frozen_string_literal: true
class ActiveEncodeDerivativeService < Hyrax::DerivativeService
  # Is this the right place for this line?
  Hyrax::DerivativeService.services = [Hyrax::ActiveEncode::ActiveEncodeDerivativeService] + Hyrax::DerivativeService.services

  def cleanup_derivatives; end

  def create_derivatives(filename)
    # TODO: Pass encode class from configuration and other output configuration (preset?)
    job_settings = []
    Hydra::Derivatives::ActiveEncodeDerivatives.create(filename, outputs: [job_settings])
  end

  # What should this return?
  def derivative_url(_destination_name)
    ""
  end

  def valid?
    supported_mime_types.include?(mime_type)
  end

  private

    def supported_mime_types
      file_set.class.audio_mime_types + file_set.class.video_mime_types
    end
end
