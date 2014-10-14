# -*- coding: utf-8 -*-
Usblamp::CLI.slop.command 'blink' do
  banner 'Usage: usblamp blink [OPTIONS]'
  description 'Blink effect'
  separator "\nOptions:\n"

  Usblamp::CLI.slop.options.each do |c|
    next if c.long == 'version'
    options << c
  end

  on :t=, :times=, 'Times', as: Integer, default: 2

  run do |opts, _args|
    lamp = Usblamp::Controller.new
    lamp.open
    lamp.switch_off
    lamp.blink(opts[:t], lamp.parse(opts))
  end
end
