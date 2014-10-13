# -*- coding: utf-8 -*-
Usblamp::CLI.slop.command 'fadein' do
  banner 'Usage: usblamp fadein [OPTIONS]'
  description 'Fade in effect'
  separator "\nOptions:\n"

  Usblamp::CLI.slop.options.each do |c|
    next if c.long == 'version'
    options << c
  end

  on :d=, :delay=, 'Delay', as: Integer, default: 2

  run do |opts, _args|
    lamp = Usblamp::Controller.new
    lamp.open
    lamp.switch_off
    lamp.fade_in(opts[:d], lamp.parse(opts))
  end
end
