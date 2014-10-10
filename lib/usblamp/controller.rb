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
      @device = usb.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID).first
      return false if connected?
      @device.open_interface(0)
    end

    def connected?
      @device.nil?
    end

    def prepare
      send(INIT_PACKET1)
      send(INIT_PACKET2)
    end

    def send(data)
      request_type =
      request = 0x09
      value = 0x81
      index = 0x00
      timeout = 100

      return True if device.ctrl_transfer(
            request_type,
            request,
            value,
            index,
            data,
            timeout
        ) == 8

      false
    end
  end
end
