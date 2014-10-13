# -*- coding: utf-8 -*-
module Usblamp
  # CLI mode
  module CLI
    ##
    # Hash containing the default Slop options.
    #
    # @return [Hash]
    #
    SLOP_OPTIONS = {
      strict: true,
      help: true,
      banner: 'Usage: usblamp [COMMAND] [OPTIONS]'
    }

    ##
    # @return [Slop]
    #
    def self.slop
      @slop ||= default_slop
    end

    ##
    # @return [Slop]
    #
    def self.default_slop
      Slop.new(SLOP_OPTIONS.dup) do
        separator "\nOptions:\n"

        on :v, :version, 'Shows the current version' do
          puts CLI.version_information
        end

        on :r=, :red=, 'Red', as: Integer
        on :g=, :green=, 'Green', as: Integer
        on :b=, :blue=, 'Blue', as: Integer
        on :c=, :color=, 'Color'

        run do |opts, _args|
          lamp = Controller.new
          lamp.open
          lamp.switch_off
          lamp.send_color(lamp.parse(opts))
        end
      end
    end

    ##
    # Returns a String containing some platform/version related information.
    #
    # @return [String]
    #
    def self.version_information
      "usblamp v#{VERSION} on #{RUBY_DESCRIPTION}"
    end
  end
end
