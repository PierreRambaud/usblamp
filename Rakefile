# -*- coding: utf-8 -*-
require 'bundler/gem_tasks'

GEMSPEC = Gem::Specification.load('usblamp.gemspec')

Dir['./task/*.rake'].each do |task|
  import(task)
end

task default: [:rubocop, :spec]
