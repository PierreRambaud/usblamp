import usb
import time
from usblamp import Color


class USBLamp:
    VENDOR_ID = 0x1d34
    PRODUCT_ID = 0x0004
    INIT_PACKET1 = (0x1F, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x03)
    INIT_PACKET2 = (0x00, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x04)
    device = None
    color = None

    def __init__(self):
        self.device = None

    def open(self):
        device = usb.core.find(
            idVendor=self.VENDOR_ID,
            idProduct=self.PRODUCT_ID
        )

        if device is None:
            return False

        self.device = device
        if self.device.is_kernel_driver_active(0):
            self.device.detach_kernel_driver(0)
        self.device.set_configuration()

        return self

    def is_connected(self):
        return self.device is not None

    def prepare(self):
        self.send(self.INIT_PACKET1)
        self.send(self.INIT_PACKET2)

    def send(self, data):
        request_type = usb.TYPE_CLASS + usb.RECIP_INTERFACE
        request = 0x09
        value = 0x81
        index = 0x00
        timeout = 100
        return True if self.device.ctrl_transfer(
            request_type,
            request,
            value,
            index,
            data,
            timeout
        ) == 8 else False

    def set_color(self, color):
        if not isinstance(color, Color):
            raise TypeError("Must be an instance of Color")

        self.color = color
        data = (
            color.red,
            color.green,
            color.blue,
            0x00,
            0x00,
            0x00,
            0x00,
            0x05
        )
        self.send(data)

    def switch_off(self):
        self.set_color(Color("black"))

    def blink(self, times, new_color):
        for i in range(int(times)):
            self.set_color(new_color)
            time.sleep(0.5)
            self.switch_off()
            time.sleep(0.5)

    def fade_in(self, delay, new_color):
        delay = int(delay)
        c = Color()
        max_value = max(new_color.red, new_color.green, new_color.blue)
        for i in range(max_value):
            time.sleep((delay * 1000 / max_value + 1) / 1000)
            c.red = self.__transition(
                i,
                self.color.red,
                new_color.red,
                max_value
            )
            c.green = self.__transition(
                i,
                self.color.green,
                new_color.green,
                max_value
            )
            c.blue = self.__transition(
                i,
                self.color.blue,
                new_color.blue,
                max_value
            )
            self.set_color(c)

    def __transition(self, index, start_point, end_point, maximum):
        return int(
            ((start_point + (end_point - start_point)) * (index + 1)) / maximum
        )
