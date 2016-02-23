# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'o365/version'

Gem::Specification.new do |spec|
  spec.name          = "O365"
  spec.version       = O365::VERSION
  spec.licenses         = ['MIT']
  spec.authors       = ["Jason Johnston", "David Verrier"]
  spec.email         = ["jasonjoh@microsoft.com", "dverrier@gmail.com"]

  spec.summary       = %q{A ruby gem to invoke the Office 365 REST APIs.}
  spec.description   = %q{This ruby gem provides functions for common operations with the Office 365 Mail, Calendar, and Contacts APIs.}
  spec.homepage      = "https://github.com/jasonjoh/ruby_outlook"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end
  
  spec.add_dependency "faraday", "~> 0.9.2"
  spec.add_dependency "uuidtools", "~> 2.3", '>= 2.3.8'

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.5"
end
