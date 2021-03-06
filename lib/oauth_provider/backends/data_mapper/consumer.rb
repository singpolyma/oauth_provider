module OAuthProvider
  module Backends
    class DataMapper
      class Consumer
        include ::DataMapper::Resource

        property :id, Serial
        property :callback, String, :unique => true, :nullable => false
        property :shared_key, String, :unique => true, :nullable => false
        property :secret_key, String, :unique => true, :nullable => false

        has n, :user_requests, :class_name => 'UserRequest'
        has n, :user_accesses, :class_name => 'UserAccess'

        def token
          OAuthProvider::Token.new(shared_key, secret_key)
        end

        def to_oauth(backend)
          OAuthProvider::Consumer.new(backend, backend.provider, callback, token)
        end
      end
    end
  end
end
