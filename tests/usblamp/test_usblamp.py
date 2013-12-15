import unittest
import usb
from mock import patch, Mock, call
from usblamp import USBLamp, Color


class USBLampTest(unittest.TestCase):
    usblamp = None

    def setUp(self):
        self.usblamp = USBLamp()

    def test_init(self):
        self.assertEqual(0x1d34, self.usblamp.VENDOR_ID)
        self.assertEqual(0x0004, self.usblamp.PRODUCT_ID)
        self.assertEqual(
            (0x1F, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x03),
            self.usblamp.INIT_PACKET1
        )
        self.assertEqual(
            (0x00, 0x01, 0x29, 0x00, 0xB8, 0x54, 0x2C, 0x04),
            self.usblamp.INIT_PACKET2
        )
        self.assertIsNone(self.usblamp.device)

    def test_open_without_usblamp(self):
        with patch("usb.core.find", return_value=None) as find_patch:
            self.assertFalse(self.usblamp.open())
            self.assertFalse(self.usblamp.is_connected())
            find_patch.assert_called_once_with(
                idVendor=self.usblamp.VENDOR_ID,
                idProduct=self.usblamp.PRODUCT_ID
            )
            self.assertIsNone(self.usblamp.device)

    def test_open_with_device(self):
        device = Mock(spec=usb.core.Device)
        device.is_kernel_driver_active.return_value = True
        device.detach_kernel_driver.return_value = None
        device.set_configuration.return_value = None

        with patch("usb.core.find", return_value=device) as find_patch:
            self.assertIsInstance(self.usblamp.open(), USBLamp)
            self.assertTrue(self.usblamp.is_connected())
            find_patch.assert_called_once_with(
                idVendor=self.usblamp.VENDOR_ID,
                idProduct=self.usblamp.PRODUCT_ID
            )
            device.is_kernel_driver_active.assert_called_once_with(0)
            device.detach_kernel_driver.assert_called_once_with(0)
            device.set_configuration.assert_called_once_with()
            self.assertIsInstance(self.usblamp.device, usb.core.Device)
            device.is_kernel_driver_active.return_value = False
            self.assertIsInstance(self.usblamp.open(), USBLamp)

    def test_send_with_error(self):
        device = Mock(spec=usb.core.Device)
        device.ctrl_transfer.return_value = 1
        self.usblamp.device = device
        self.assertFalse(self.usblamp.send('test'))
        device.ctrl_transfer.assert_called_once_with(
            usb.TYPE_CLASS + usb.RECIP_INTERFACE,
            0x09,
            0x81,
            0x00,
            'test',
            100,
        )

    def test_send(self):
        device = Mock(spec=usb.core.Device)
        device.ctrl_transfer.return_value = 8
        self.usblamp.device = device
        self.assertTrue(self.usblamp.send(111))
        device.ctrl_transfer.assert_called_once_with(
            usb.TYPE_CLASS + usb.RECIP_INTERFACE,
            0x09,
            0x81,
            0x00,
            111,
            100,
        )

    def test_prepare(self):
        device = Mock(spec=usb.core.Device)
        device.ctrl_transfer.return_value = 8
        self.usblamp.device = device
        self.usblamp.prepare()
        assert device.ctrl_transfer.mock_calls == [
            call(
                usb.TYPE_CLASS + usb.RECIP_INTERFACE,
                0x09,
                0x81,
                0x00,
                self.usblamp.INIT_PACKET1,
                100
            ),
            call(
                usb.TYPE_CLASS + usb.RECIP_INTERFACE,
                0x09,
                0x81,
                0x00,
                self.usblamp.INIT_PACKET2,
                100
            )
        ]

    def test_set_color_with_error(self):
        self.assertRaises(TypeError, self.usblamp.set_color, "test")

    def test_set_color(self):
        color = Color("cyan")
        device = Mock(spec=usb.core.Device)
        device.ctrl_transfer.return_value = 8
        self.usblamp.device = device
        self.usblamp.set_color(color)
        device.ctrl_transfer.assert_called_once_with(
            usb.TYPE_CLASS + usb.RECIP_INTERFACE,
            0x09,
            0x81,
            0x00,
            (color.red, color.green, color.blue, 0x00, 0x00, 0x00, 0x00, 0x05),
            100
        )

    def test_set_color(self):
        device = Mock(spec=usb.core.Device)
        device.ctrl_transfer.return_value = 8
        self.usblamp.device = device
        self.usblamp.switch_off()
        device.ctrl_transfer.assert_called_once_with(
            usb.TYPE_CLASS + usb.RECIP_INTERFACE,
            0x09,
            0x81,
            0x00,
            (0, 0, 0, 0x00, 0x00, 0x00, 0x00, 0x05),
            100
        )
