# frozen_string_literal: true

require_relative "client/version"
require "faraday"
require "uri"
require "oj"

module Localisation
  module Api
    module Client
      class TranslationError < StandardError; end
      # Your code goes here...
      class Translate
        def initialize(service_url:, key: false)
          @service = URI(service_url)
          @api_key = key
        end # translate



        def fetch_translations(original:, locale_code:)

          parameters = {}
          parameters[:api_key] = @api_key if @api_key

          # service should support POST requests
          # because some strings may be larger than 256 chars

          con = Faraday.new service_address
          res = con.post @service.path, parameters

          # TODO handle errors?
          Oj.load(res.body)

        end # fetch_translations


        def translate_one(original:, locale_code: )
          translations = fetch_translations(original: original, locale_code: locale_code)
          
          raise Localisation::Api::Client::TranslationError.new("No translations found!") if !translations || translations.size == 0

          translations.first
        end # translate_one


        def translate_many(originals:, locale_code:)
          to_translate = [ originals ].flatten.compact.uniq
          translations = []

          to_translate.each do |o|
            translations << translate_one(original: o, locale_code: locale_code)
          end

          translations
        end # translate_many
        
        private
        def service_address
          "#{ @service.scheme }://#{ @service.hostname }:#{ @service.port }"
        end # service_host
      end # Translate
    end
  end
end
