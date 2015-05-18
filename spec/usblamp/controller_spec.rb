# -*- coding: utf-8 -*-
require 'spec_helper'
require 'libusb'
require 'usblamp/controller'

# Usblamp module
# rubocop:disable Metrics/ModuleLength
module Usblamp
  describe 'Controller' do
    before(:each) do
      @controller = Controller.new
    end

    it 'should test init' do
      expect(@controller.device).to be(nil)
      expect(@controller.color).to be(nil)
    end

    it 'should test const' do
      expect(Controller::VENDOR_ID).to eq(0x1d34)
      expect(Controller::PRODUCT_ID).to eq(0x0004)
      expect(Controller::INIT_PACKET1)
        .to eq([31, 1, 41, 0, 184, 84, 44, 3])
      expect(Controller::INIT_PACKET2)
        .to eq([0, 1, 41, 0, 184, 84, 44, 4])
      expect(@controller.device).to eq(nil)
    end

    it 'should raise when no supported devices found' do
      device = double(devices: [])
      allow(LIBUSB::Context).to receive(:new).and_return(device)
      expect { @controller.open }.to raise_error(RuntimeError)
    end

    it 'should open device' do
      handle = spy(open: true,
                   kernel_driver_active?: true,
                   detach_kernel_driver: true,
                   control_transfer: 8)
      device = double(devices: [double(open: handle)])
      allow(LIBUSB::Context).to receive(:new).and_return(device)
      expect(@controller.open).to be_truthy
      expect(handle).to have_received(:claim_interface).with(0)
      expect(handle).to have_received(:control_transfer)
        .with(bmRequestType: 33,
              bRequest: 9,
              wValue: 129,
              wIndex: 0,
              dataOut: [31, 1, 41, 0, 184, 84, 44, 3].map(&:chr).reduce(:+),
              timeout: 10)
      expect(handle).to have_received(:control_transfer)
        .with(bmRequestType: 33,
              bRequest: 9,
              wValue: 129,
              wIndex: 0,
              dataOut: [0, 1, 41, 0, 184, 84, 44, 4].map(&:chr).reduce(:+),
              timeout: 10)
    end

    it 'should fail send transfer' do
      device = double(control_transfer: 5)
      @controller.device = device
      expect(@controller.send([0])).to be_falsy
    end

    it 'should test send_color parameter' do
      expect { @controller.send_color('fake') }
        .to raise_error(TypeError, 'Parameter must be an instance of Color')
    end

    it 'should send color' do
      device = spy(control_transfer: 8)
      @controller.device = device
      expect(@controller.send_color(Color.new('blue'))).to be_truthy
      expect(device).to have_received(:control_transfer)
        .with(bmRequestType: 33,
              bRequest: 9,
              wValue: 129,
              wIndex: 0,
              dataOut: [0, 0, 64, 0, 0, 0, 0, 5].map(&:chr).reduce(:+),
              timeout: 10)
    end

    it 'should switch off' do
      device = spy(control_transfer: 8)
      @controller.device = device
      expect(@controller.switch_off).to be_truthy
      expect(device).to have_received(:control_transfer)
        .with(bmRequestType: 33,
              bRequest: 9,
              wValue: 129,
              wIndex: 0,
              dataOut: "\x00\x00\x00\x00\x00\x00\x00\x05",
              timeout: 10)
    end

    it 'should parse args to create color' do
      args = { c: 'red' }
      result = @controller.parse(args)
      expect(result).to be_a(Color)
      expect(result.red).to eq(64)
      expect(result.green).to eq(0)
      expect(result.blue).to eq(0)

      args = { r: 10, g: 10, b: 10 }
      result = @controller.parse(args)
      expect(result).to be_a(Color)
      expect(result.red).to eq(10)
      expect(result.green).to eq(10)
      expect(result.blue).to eq(10)
    end

    it 'should fade in' do
      device = spy(control_transfer: 8)
      @controller.color = Color.new('black')
      @controller.device = device
      allow(@controller).to receive(:sleep).and_return(true)
      expect(@controller.fade_in(2, Color.new('blue'))).to be_truthy
      (1..64).each do |i|
        expect(device).to have_received(:control_transfer)
          .with(bmRequestType: 33,
                bRequest: 9,
                wValue: 129,
                wIndex: 0,
                dataOut: [0, 0, i, 0, 0, 0, 0, 5].map(&:chr).reduce(:+),
                timeout: 10)
      end
    end

    it 'should blink' do
      device = spy(control_transfer: 8)
      @controller.device = device
      allow(@controller).to receive(:sleep).and_return(true)
      expect(@controller.blink(2, Color.new('blue'))).to be_truthy
      (1..2).each do
        expect(device).to have_received(:control_transfer).twice
          .with(bmRequestType: 33,
                bRequest: 9,
                wValue: 129,
                wIndex: 0,
                dataOut: [0, 0, 64, 0, 0, 0, 0, 5].map(&:chr).reduce(:+),
                timeout: 10)
        expect(device).to have_received(:control_transfer).twice
          .with(bmRequestType: 33,
                bRequest: 9,
                wValue: 129,
                wIndex: 0,
                dataOut: [0, 0, 0, 0, 0, 0, 0, 5].map(&:chr).reduce(:+),
                timeout: 10)
      end
    end
  end
end
