# frozen_string_literal: true
Rails.application.routes.draw do
  mount Hyrax::ActiveEncode::Engine, at: '/'

  resources :encode_record, only: [:show, :index], controller: 'hyrax/active_encode/encode_record' do
    collection do
      post :paged_index
    end
  end
end
