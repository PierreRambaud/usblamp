# -*- coding: utf-8 -*-
# Usblamp module
module Usblamp
  # Controller class
  class Controller
    attr_accessor :device, :color

    VENDOR_ID = 0x1d34
    PRODUCT_ID = 0x0004
    INIT_PACKET1 = %w(0x1F 0x01 0x29 0x00 0xB8 0x54 0x2C 0x03)
    INIT_PACKET2 = %w(0x00 0x01 0x29 0x00 0xB8 0x54 0x2C 0x04)

    def initiliaze
      @device = nil
    end

    def open
      usb = LIBUSB::Context.new
      device = usb.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID).first

      fail 'Could no find a supported device.' if device.nil?
      @device = device.open_interface(0)
    end

    def prepare
      send(INIT_PACKET1)
      send(INIT_PACKET2)
    end

    def send(data)
      return true if @device
        .usb_control_msg(
                         REQUEST_TYPE_CLASS | RECIPIENT_INTERFACE,
                         REQUEST_SET_CONFIGURATION,
                         0x81,
                         ENDPOINT_OUT,
                         data,
                         10) == 8

      false
    end
  end
end
