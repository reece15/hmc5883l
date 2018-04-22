# coding:utf-8

import smbus
import math
import time

class hmc5883l(object):

    __scales = {
        0.88: [0, 0.73],
        1.30: [1, 0.92],
        1.90: [2, 1.22],
        2.50: [3, 1.52],
        4.00: [4, 2.27],
        4.70: [5, 2.56],
        5.60: [6, 3.03],
        8.10: [7, 4.35],
    }

    def __init__(self, port=1, address=0x1E, gauss=4.7, declination=(0,0), offset=None):
        """

        :param port:
        :param address:
        :param gauss:
        :param declination: 磁偏角
        :param offset:  矫正  xc,yc,a,b
        :return:
        """
        self.bus = smbus.SMBus(port)
        self.address = address

        self.offset = None
        if offset:
            self.offset = offset

        (degrees, minutes) = declination
        self.__declDegrees = degrees
        self.__declMinutes = minutes
        self.__declination = (degrees + minutes / 60)*math.pi/180

        (self.reg, self.__scale) = self.__scales[gauss]

        self.reg_a = 0x70
        self.reg_b = self.reg << 5
        self.reg_c = 0x00
        self.bus.write_byte_data(self.address, 0x00, self.reg_a) # 8 Average, 15 Hz, normal measurement
        self.bus.write_byte_data(self.address, 0x01, self.reg_b) # Scale
        self.bus.write_byte_data(self.address, 0x02, self.reg_c) # Continuous measurement

    def self_test(self):

        print self.self_test_int_data()

        self.bus.write_byte_data(self.address, 0x01, 5<<5)
        self.bus.write_byte_data(self.address, 0x00, 0x71)
        self.bus.write_byte_data(self.address, 0x02, 0x00)

        time.sleep(0.5)

        data = self.self_test_int_data()
        flag = not any(filter(lambda x: True if x > 243 and x < 575 else False, data))
        if flag:
            print "self test failed!"
        else:
            print "self test pass!"
        print "x:{},y:{},z:{}---gain:5  243<val<575".format(*data)

        self.bus.write_byte_data(self.address, 0x00, self.reg_a)
        self.bus.write_byte_data(self.address, 0x01, self.reg_b)
        self.bus.write_byte_data(self.address, 0x02, self.reg_c)

        return flag

    def self_test_int_data(self):
        data = self.bus.read_i2c_block_data(self.address, 0x03, 6)
        x = self.twos_complement(data[0] << 8 | data[1], 16)
        z = self.twos_complement(data[2] << 8 | data[3], 16)
        y = self.twos_complement(data[4] << 8 | data[5], 16)

        return x,y,z

    def self_test_bin_data(self):
        data = self.bus.read_i2c_block_data(self.address, 0x03, 6)
        d = list(map(lambda x: (8 - len(x))*'0'+ x, map(lambda x:bin(x)[2:], data)))
        x = d[0]+d[1]
        z = d[2]+d[3]
        y = d[4]+d[5]

        print "x:{x},y:{y},z:{z}".format(**vars())

        return x, y, z


    def declination(self):
        return (self.__declDegrees, self.__declMinutes)

    def twos_complement(self, val, len):
        # Convert twos compliment to integer
        if (val & (1 << len - 1)):
            return -((65535 - val) + 1)
        return val

    def __convert(self, data, offset):
        val = self.twos_complement(data[offset] << 8 | data[offset+1], 16)
        if val == -4096: return None
        return round(val * self.__scale, 4)

    def axes(self):
        data = self.bus.read_i2c_block_data(self.address, 0x00)
        #print map(hex, data)
        x = self.__convert(data, 3)
        y = self.__convert(data, 7)
        z = self.__convert(data, 5)
        return (x,y,z)

    def fix(self, x, y):
        xc, yc, a, b = self.offset
        x -= xc
        y -= yc
        if a > b:
            y = y * (a/b)
        else:
            y = y * (b/a)
        return x, y


    def heading(self):
        (x, y, z) = self.axes()



        if self.offset:
            x, z = self.fix(x, z)

        headingRad = math.atan2(z, x) # 由于测试发现y轴飘逸严重，换用z轴和x轴
        headingRad += self.__declination

        # Correct for reversed heading
        if headingRad < 0:
            headingRad += 2 * math.pi

        # Check for wrap and compensate
        elif headingRad > 2 * math.pi:
            headingRad -= 2 * math.pi

        # Convert to degrees from radians
        headingDeg = headingRad * 180 / math.pi
        return headingDeg

    def degrees(self, headingDeg):
        degrees = math.floor(headingDeg)
        minutes = round((headingDeg - degrees) * 60)
        return (degrees, minutes)

    def __str__(self):
        (x, y, z) = self.axes()
        return "Axis X: " + str(x) + "\n" \
               "Axis Y: " + str(y) + "\n" \
               "Axis Z: " + str(z) + "\n" \
               "Declination: " + self.degrees(self.declination()) + "\n" \
               "Heading: " + self.degrees(self.heading()) + "\n"

def test_fix():
    """
    校准 传感器 使用的是x z轴
    :return:
    """
    x_gain=1

    x_max = 0
    y_max = 0
    x_min = 0
    y_min = 0
    compass = hmc5883l(port=1, declination=(4,37))
    while True:
        x,z,y = compass.axes() # 使用的是x z轴
        x_max = max(x, x_max)
        y_max = max(y, y_max)

        x_min = min(x, x_min)
        y_min = min(y, y_min)

        time.sleep(0.1)
        x_offset = (x_max + x_min) / 2
        y_offset = (y_max + y_min) / 2
        y_gain= (x_max - x_min) / (y_max - y_min)


        x_hmc = x_gain *(x -x_offset)
        y_hmc = y_gain *(y -y_offset)
        d = math.atan2(x, y) * 180 / math.pi + 180
        d_hmc = math.atan2(x_hmc, y_hmc) * 180 / math.pi + 180
        print "x:{x},y:{y},z:{z},x_max:{x_max},x_min:{x_min},y_max:{y_max},y_min:{y_min}".format(**vars())
        print "x_offset:{x_offset},y_offset:{y_offset},y_gain:{y_gain},d:{d},d_hmc:{d_hmc}".format(**vars())

def test_deg():
    """
    测试角度
    :return:
    """
    compass = hmc5883l(port=1, declination=(37,37), gauss=4.7,offset=(23.4605, 45.2855, 298.3074, 264.1171))

    time.sleep(1)
    compass.heading()
    time.sleep(0.1)

    while True:
        print compass.heading()
        time.sleep(0.5)

def test_plot():
    """
    输出可绘制的数据  注意是 z x轴的
    python hmc5883l.py test_plot > 1.plot
    cat 1.plot | awk 'BEGIN{res="["}{res=res $1" "$2";";}END{res=res"]";print res}'
    :return:
    """
    compass = hmc5883l(port=1, declination=(4,37), offset=(-169.28, 119.14, 1, 0.773172569706))

    time.sleep(1)
    compass.heading()
    time.sleep(0.1)

    x_max = 0
    y_max = 0
    x_min = 0
    y_min = 0
    x_gain = 1
    while True:
        x,z,y = compass.axes() # 注意是 z x轴的


        x_max = max(x, x_max)
        y_max = max(y, y_max)

        x_min = min(x, x_min)
        y_min = min(y, y_min)

        time.sleep(0.5)
        x_offset = (x_max + x_min) / 2
        y_offset = (y_max + y_min) / 2
        y_gain= (x_max - x_min) / (y_max - y_min)


        x_hmc = x_gain *(x -x_offset)
        y_hmc = y_gain *(y -y_offset)

        print x, y, x_hmc, y_hmc, x_offset, y_offset, y_gain
        time.sleep(0.1)

def test_self_test():
    """
    自测
    :return:
    """
    compass = hmc5883l(port=1)
    compass.self_test()


def error_deal():
    print "cmd: sudo python {} [argv]".format(sys.argv[0], )

    print "argv:"
    funcs = filter(lambda k: True if k[0].startswith("test") and callable(k[1]) else False, globals().items())

    for func in funcs:
        print "-----{}".format(func[0])
        print func[1].func_doc

if __name__ == "__main__":
    import sys
    args = len(sys.argv)

    if args >= 2:

        if sys.argv[1].startswith("test"):
            func = vars().get(sys.argv[1])
            if callable(func):
                func()
            else:
                print "not callable:{} {}".format(sys.argv[1], func)
                error_deal()
        else:
            print "not found!"
            error_deal()
    else:
        error_deal()