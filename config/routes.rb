# frozen_string_literal: true
Hyrax::ActiveEncode::Engine.routes.draw do
  resources :encode_records, only: [:show, :index] do
    collection do
      post :paged_index
    end
  end
end
