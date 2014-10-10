# -*- coding: utf-8 -*-
module Gemirro
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
    def self.options
      @options ||= default_options
    end

    ##
    # @return [Slop]
    #
    def self.default_options
      Slop.new(SLOP_OPTIONS.dup) do
        separator "\nOptions:\n"

        on :v, :version, 'Shows the current version' do
          puts CLI.version_information
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
