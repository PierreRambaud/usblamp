# -*- coding: utf-8 -*-
require File.expand_path('../lib/usblamp/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'usblamp'
  s.version     = Usblamp::VERSION
  s.date        = '2014-10-10'
  s.authors     = ['Pierre Rambaud']
  s.email       = 'pierre.rambaud86@gmail.com'
  s.license     = 'GPL-3.0'
  s.summary     = 'WebMail Notifier with ruby (Dream Cheeky).'
  s.homepage    = 'https://github.com/PierreRambaud/usblamp'
  s.description = 'WebMail Notifier with ruby (Dream Cheeky).'
  s.executables = ['usblamp']

  s.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'slop', '~>3.6'
  s.add_dependency 'libusb', '~>0.4'

  s.add_development_dependency 'rake', '~>10.0'
  s.add_development_dependency 'rspec', '~>3.0'
  s.add_development_dependency 'simplecov', '~>0.9'
  s.add_development_dependency 'rubocop', '~>0.25'
end
