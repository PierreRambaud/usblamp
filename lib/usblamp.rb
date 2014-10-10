# -*- coding: utf-8 -*-
require 'slop'
require 'libusb'

unless $LOAD_PATH.include?(File.expand_path('../', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../', __FILE__))
end

require 'usblamp/version'

require 'usblamp/cli'
