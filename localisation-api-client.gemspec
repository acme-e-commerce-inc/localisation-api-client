# frozen_string_literal: true

require_relative "lib/localisation/api/client/version"

Gem::Specification.new do |spec|
  spec.name          = "localisation-api-client"
  spec.version       = Localisation::Api::Client::VERSION
  spec.authors       = ["Netenders"]
  spec.email         = ["gems@netenders.com"]

  spec.summary       = "Localisation service client."
  spec.description   = "Connect to the localisation service and submit content for automated translation."
  spec.homepage      = "https://github.com/needen/localisation-api-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/needen/localisation-api-client"
  spec.metadata["changelog_uri"] = "https://github.com/needen/localisation-api-client/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "faraday", "~> 2.7.10"
  spec.add_dependency "oj", "~> 3.15.1"

end
