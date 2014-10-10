# -*- coding: utf-8 -*-
require 'spec_helper'
require 'libusb'
require 'usblamp/controller'

# Usblamp module
module Usblamp
  describe 'Controller' do
    before(:each) do
      @controller = Controller.new
    end

    it 'should test const' do
      expect(Controller::VENDOR_ID).to eq(0x1d34)
      expect(Controller::PRODUCT_ID).to eq(0x0004)
      expect(Controller::INIT_PACKET1)
        .to eq(%w(0x1F 0x01 0x29 0x00 0xB8 0x54 0x2C 0x03))
      expect(Controller::INIT_PACKET2)
        .to eq(%w(0x00 0x01 0x29 0x00 0xB8 0x54 0x2C 0x04))
      expect(@controller.device).to eq(nil)
    end

    it 'should raise when no supported devices found' do
      allow(LIBUSB::Context).to receive(:devices).and_return([])
      expect { @controller.open }.to raise_error(RuntimeError)
    end

    it 'should open device' do
      allow(LIBUSB::Context).to receive(:devices).and_return([true])
    end
  end
end
