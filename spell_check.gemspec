# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spell_check/version'

Gem::Specification.new do |spec|
  spec.name          = 'spell_check'
  spec.version       = SpellCheck::VERSION
  spec.authors       = ['Solberg, Garrick L']
  spec.email         = ['Garrick.Solberg@gmail.com']
  spec.summary       = %q{Checks to see if a word is correctly spelled}
  spec.description   = %q{Checks if a word exists in text dictionary.  If it does not, this gem will attempt to correct
                          the input by changing repeated characters and case.}
  spec.homepage      = 'http://www.linkedin.com/in/garricksolberg/'
  spec.license       = 'MIT'

  spec.files         = %w(lib/spell_check.rb lib/spell_check/dictionary.rb lib/spell_check/words.txt
                          lib/spell_check/version.rb)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 0'
end
