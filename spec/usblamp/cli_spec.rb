# -*- coding: utf-8 -*-
require 'spec_helper'
require 'usblamp/cli'
require 'slop'

# Usblamp tests
module Usblamp
  # CLI tests
  module CLI
    describe 'CLI' do
      it 'should return options' do
        options = CLI.slop
        expect(options).to be_a(::Slop)
        expect(options.config[:strict]).to be_truthy
        expect(options.config[:banner])
          .to eq('Usage: usblamp [COMMAND] [OPTIONS]')
        expect(options.to_s)
          .to match(/-v, --version(\s+)Shows the current version/)
        expect(options.to_s)
          .to match(/-h, --help(\s+)Display this help message./)

        version = options.fetch_option(:v)
        expect(version.short).to eq('v')
        expect(version.long).to eq('version')
        expect { version.call }.to output(/usblamp v.* on ruby/).to_stdout
      end

      it 'should retrieve version information' do
        expect(CLI.version_information).to eq(
          "usblamp v#{VERSION} on #{RUBY_DESCRIPTION}"
        )
      end

      it 'should change color' do
        controller = double(open: true,
                            switch_off: true,
                            parse: { c: 'blue' },
                            send_color: true)
        allow(Controller).to receive(:new).and_return(controller)
        expect(CLI.slop.parse(c: 'blue')).to eq(c: 'blue')
      end
    end
  end
end
