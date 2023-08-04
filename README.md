Getting started

Include the gem in your Gemfile either from the GH repo (authentication required)

```
gem "localisation-api-client", git: "https://github.com/needen/localisation-api-client"
```

... or from a local path provided you cloned the repo there:

```
gem "localisation-api-client", path: "/path/to/localisation-api-client"
```

# Usage

## Start required services
First, start the `localisation-api` and `localisation-service` services. Make note of the URL to the `localisation-api` service. 

## Create a client object
```
translator = Localisation::Api::Client::Translate.new(service_url: <api_url>, key: false)
```
If at any point you get an authentication error, you must supply an API key as well.

## Send translation requests
Translate a single String:
```
translator.translate_one(original: "Hello Kitty!", locale_code: "en-US)
```
Translate multiple:

```
translator.translate_many(originals: [ "Hello Kitty!", "Hello Dolly!" ], locale_code: "en-US)
```

## Best practice
In your application create an `LocalisationHelper` as follows:

```
module LocalisationHelper
    def api_url
        # TODO get it from some settings store somewhere?
        # you can have multiple services (staging, production, updates...)
        # a setting management UI will allow operators to change to a different translations database
        # on the fly without developer support

        "https://localisation.netenders.com:8080/translate"
    end # api_url

    def api_key
        # TODO get it from some settings store somewhere?
        false
    end # 

    def detect_locale
        # TODO should come out of an FeatureDetectionHelper or wherever
        "en-us"
    end #

    def translate(str, locale = detect_locale)
        $translator ||= Localisation::Api::Client::Translate.new(service_url: api_url, key: api_key)
        output = $translator.translate_one( original: str, locale_code: detect_locale)
        output.first[:translation]
    end # translate
end
```

## Notes
The client may return multiple translations with different locales under the same locale code. 
This means that for any English request (en-us, en-GB, en_AU, en) it may return variants for en-us, en-ca, en-au. Typically you can use any of them but at some point someone will start to nitpick (eg "localise", "localiSe"! Not "localize"! Her Majesty's English! You're not a wild animal!).

If no translation was found it will return the original text, in this case you may try again later as the service will translate your string in the background. 
Typically this means on a product's first occurence all descriptions will be in English, but subsequent product updates will be translated automatically.


# TODO

* when returning multiple translations make sure the locale code is included with each entry
* automated publish to Rubygems: do they make sense?