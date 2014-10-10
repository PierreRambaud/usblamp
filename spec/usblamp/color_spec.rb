# -*- coding: utf-8 -*-
require 'spec_helper'
require 'usblamp/color'

# Usblamp module
module Usblamp
  describe 'Color' do
    before(:each) do
      @color = Color.new
    end

    it 'should test initialize with color' do
      color = Color.new(10, 11, 12)
      expect(color.red).to eq(10)
      expect(color.green).to eq(11)
      expect(color.blue).to eq(12)
    end

    it 'should test const' do
      expect(Color::MAX_VALUE).to eq(0x40)
    end

    it 'should set' do
      @color.set(10, 11, 12)
      expect(@color.red).to eq(10)
      expect(@color.green).to eq(11)
      expect(@color.blue).to eq(12)
    end

    it 'should set from hex' do
      @color.set('#112233')
      expect(@color.red).to eq(17)
      expect(@color.green).to eq(34)
      expect(@color.blue).to eq(51)
      @color.set('_112233')
      expect(@color.red).to eq(17)
      expect(@color.green).to eq(34)
      expect(@color.blue).to eq(51)
      @color.set('#123')
      expect(@color.red).to eq(17)
      expect(@color.green).to eq(34)
      expect(@color.blue).to eq(51)
    end

    it 'should set from string' do
      @color.set('red')
      expect(@color.red).to eq(64)
      expect(@color.green).to eq(0)
      expect(@color.blue).to eq(0)
      @color.set('green')
      expect(@color.red).to eq(0)
      expect(@color.green).to eq(64)
      expect(@color.blue).to eq(0)
      @color.set('blue')
      expect(@color.red).to eq(0)
      expect(@color.green).to eq(0)
      expect(@color.blue).to eq(64)
      @color.set('white')
      expect(@color.red).to eq(64)
      expect(@color.green).to eq(64)
      expect(@color.blue).to eq(64)
      @color.set('magenta')
      expect(@color.red).to eq(64)
      expect(@color.green).to eq(0)
      expect(@color.blue).to eq(64)
      @color.set('cyan')
      expect(@color.red).to eq(0)
      expect(@color.green).to eq(64)
      expect(@color.blue).to eq(64)
      @color.set('yellow')
      expect(@color.red).to eq(64)
      expect(@color.green).to eq(64)
      expect(@color.blue).to eq(0)
      @color.set('nothing')
      expect(@color.red).to eq(0)
      expect(@color.green).to eq(0)
      expect(@color.blue).to eq(0)
    end

    it 'should raise error when undefined color' do
      expect { @color.set('#FF') }.to raise_error ArgumentError
      expect { @color.set('#FFFF') }.to raise_error ArgumentError
      expect { @color.set('#FFFFF') }.to raise_error ArgumentError
    end
  end
end
