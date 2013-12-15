class Color:
    max_value = 0x40
    red = None
    green = None
    blue = None

    def __init__(self, red=None, green=None, blue=None):
        self.set(red, green, blue)

    def set(self, red, green=None, blue=None):
        if isinstance(red, str) and green is None and blue is None:
            if red[0] in ("#", "_"):
                return self.__from_hex(red)
            else:
                return self.__from_string(red)

        if red is None:
            red = 0
        if green is None:
            green = 0
        if blue is None:
            blue = 0

        self.red = self.__set_value(red)
        self.green = self.__set_value(green)
        self.blue = self.__set_value(blue)

    def __set_value(self, integer):
        return min(max(0, int(integer)), self.max_value)

    def __from_hex(self, string):
        string = string.lstrip('#_')

        if len(string) not in (3, 6):
            raise ValueError('Wrong lenght for hexadecimal string')

        if len(string) == 6:
            self.set(
                int(string[0:2], 16),
                int(string[2:4], 16),
                int(string[4:6], 16)
            )
        else:
            self.set(
                int(string[0:1]*2, 16),
                int(string[1:2]*2, 16),
                int(string[2:3]*2, 16)
            )

    def __from_string(self, string):
        if string == "red":
            return self.set(self.max_value, 0, 0)
        elif string == "green":
            return self.set(0, self.max_value, 0)
        elif string == "blue":
            return self.set(0, 0, self.max_value)
        elif string == "white":
            return self.set(self.max_value, self.max_value, self.max_value)
        elif string == "magenta":
            return self.set(self.max_value, 0, self.max_value)
        elif string == "cyan":
            return self.set(0, self.max_value, self.max_value)
        elif string == "yellow":
            return self.set(self.max_value, self.max_value, 0)
        else:
            return self.set(0, 0, 0)
