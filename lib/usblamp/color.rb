# -*- coding: utf-8 -*-
# Usblamp module
module Usblamp
  # Color class
  class Color
    attr_accessor :red, :green, :blue
    MAX_VALUE = 0x40

    def initialize(red = nil, green = nil, blue = nil)
      set(red, green, blue)
    end

    def set(red, green = nil, blue = nil)
      if red.is_a?(String) && green.nil? && blue.nil?
        if ['#', '_'].include?(red[0])
          return define_from_hex(red)
        else
          return define_from_string(red)
        end
      end

      red = 0 if red.nil?
      green = 0 if green.nil?
      blue = 0 if blue.nil?

      @red = define_value(red)
      @green = define_value(green)
      @blue = define_value(blue)
    end

    private

    def define_value(integer)
      [[0, integer.to_i].max, MAX_VALUE].min
    end

    def define_from_hex(string)
      string = string.gsub(/[#_]/, '')
      fail ArgumentError, 'Wrong length for hexadecimal string' unless
        [3, 6].include?(string.length.to_i)

      return set(string[0..1].to_i(16),
                 string[2..3].to_i(16),
                 string[4..5].to_i(16)) if string.length == 6

      set((string[0] * 2).to_i(16),
          (string[1] * 2).to_i(16),
          (string[2] * 2).to_i(16))
    end

    def define_from_string(string)
      return set(MAX_VALUE, 0, 0) if string == 'red'
      return set(0, MAX_VALUE, 0) if string == 'green'
      return set(0, 0, MAX_VALUE) if string == 'blue'
      return set(MAX_VALUE, MAX_VALUE, MAX_VALUE) if string == 'white'
      return set(MAX_VALUE, 0, MAX_VALUE) if string == 'magenta'
      return set(0, MAX_VALUE, MAX_VALUE) if string == 'cyan'
      return set(MAX_VALUE, MAX_VALUE, 0) if string == 'yellow'
      return set(MAX_VALUE / 2, MAX_VALUE / 2, MAX_VALUE / 2) if
        string == 'purple'

      set(0, 0, 0)
    end
  end
end
