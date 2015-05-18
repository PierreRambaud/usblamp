# -*- coding: utf-8 -*-
# Usblamp module
module Usblamp
  # Controller class
  class Controller
    attr_accessor :device, :color

    VENDOR_ID = 0x1d34
    PRODUCT_ID = 0x0004
    INIT_PACKET1 = [0x1F, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x03]
    INIT_PACKET2 = [0x00, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x04]

    def initialize
      @device = nil
      @color = nil
    end

    def open
      usb = LIBUSB::Context.new
      device = usb.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID).first

      fail 'Could no find a supported device.' if device.nil?
      @device = device.open
      @device.detach_kernel_driver(0) if @device.kernel_driver_active?(0)
      @device.claim_interface(0)
      send(INIT_PACKET1)
      send(INIT_PACKET2)
    end

    def send(data)
      return true if @device.control_transfer(bmRequestType:
                                              LIBUSB::REQUEST_TYPE_CLASS |
                                              LIBUSB::RECIPIENT_INTERFACE,
                                              bRequest:
                                              LIBUSB::REQUEST_SET_CONFIGURATION,
                                              wValue: 0x81,
                                              wIndex: LIBUSB::ENDPOINT_OUT,
                                              dataOut: data.map(&:chr)
                                                .reduce(:+),
                                              timeout: 10) == 8

      false
    end

    def send_color(color)
      fail TypeError, 'Parameter must be an instance of Color' unless
        color.is_a?(Color)

      @color = color
      data = [color.red,
              color.green,
              color.blue,
              0x00,
              0x00,
              0x00,
              0x00,
              0x05]
      send(data)
    end

    def switch_off
      send_color(Color.new('black'))
    end

    def parse(args)
      color = Color.new(args[:c]) unless args[:c].nil?
      color = Color.new(args[:r], args[:g], args[:b]) if args[:c].nil?
      color
    end

    def fade_in(delay, new_color)
      delay = delay.to_i
      color = Color.new
      max_value = [new_color.red, new_color.green, new_color.blue].max
      (0..max_value).each do |i|
        sleep((delay.to_f * 1000.to_f / max_value.to_f + 1.to_f) / 1000.to_f)
        color.red = transition(i,
                               @color.red,
                               new_color.red,
                               max_value)
        color.green = transition(i,
                                 @color.green,
                                 new_color.green,
                                 max_value)
        color.blue = transition(i,
                                @color.blue,
                                new_color.blue,
                                max_value)
        send_color(color)
      end
    end

    def blink(times, new_color)
      (1..times).each do
        send_color(new_color)
        sleep 0.5
        switch_off
        sleep 0.5
      end
    end

    private

    def transition(index, start_point, end_point, maximum)
      (((start_point.to_f + (end_point.to_f - start_point.to_f)) *
        (index.to_f + 1.to_f)
       ) / maximum.to_f).to_i
    end
  end
end
