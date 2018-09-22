# frozen_string_literal: true
require 'active_encode'

module Hyrax
  module ActiveEncode
    class DefaultOptionService
      # Returns default audio/video output options for ActiveEncode.
      # @param fileset the data to be persisted
      # @return an array of hashes of output options for audio/video
      def self.call(file_set)
        # Defaults adapted from hydra-derivatives
        audio_encoder = Hydra::Derivatives::AudioEncoder.new
        if file_set.audio?
          [{ outputs: [{ label: 'mp4', ffmpeg_opt: "-s 320x240 -ac 2 -ab 96k -ar 44100 -acodec #{audio_encoder.audio_encoder}" }] }]
        elsif file_set.video?
          [{ outputs: [{ label: 'mp4', ffmpeg_opt: "-s 320x240 -g 30 -b:v 345k -ac 2 -ab 96k -ar 44100 -vcodec libx264 -acodec #{audio_encoder.audio_encoder}" }] }]
        else
          []
        end
      end
    end
  end
end
