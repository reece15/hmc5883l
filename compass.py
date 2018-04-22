# coding:utf-8


from libs.hmc5883l import hmc5883l
import car_statics
import traceback

class Compass(hmc5883l):

    def __init__(self):
        super(Compass, self).__init__(port=car_statics.COMPASS_PORT, declination=car_statics.COMPASS_DES, offset=car_statics.COMPASS_OVAL)
        self.now_deg = None
        self.now_deg_str = u"正在搜索方位"
        self.loss = car_statics.COMPASS_LOSS
        self.deg_mapping = [
            (270-45, 270+45, u"南", 270, u"南偏东", u"南偏西"), # 最小角度 最大角度 方位名称 正方位角度 大于正方位的名称 小于正方位的名称
            (90-45, 90+45, u"北", 90, u"北偏西", u"北偏东"),
            (180-45, 180+45, u"西", 180, u"西偏南", u"西偏北"),
            (360-45, 361, u"东", 360, u"", u"东偏南"),
            (0, 45, u"东", 0, u"东偏北", u""),

        ]
    def update(self):
        try:
            self.now_deg = self.heading()
            self.now_deg_str = self.render_dire(self.now_deg)
        except Exception as e:
            print traceback.format_exc()
            return None
        else:
            return self.now_deg

    def render_dire(self, deg):

        now_deg_str = u"正在搜索方位"
        for d_min, d_max, d_name, d_point, d_big, d_small in self.deg_mapping:
            if d_min <= deg <= d_max:  # 如果在方位范围内
                if d_point+self.loss[1]-2 <= deg <= d_point + self.loss[0]+2:  # 且忽略误差后在正方位
                    now_deg_str = d_name
                else:
                    d_sub = deg - d_point

                    deg_abs = abs(d_sub)
                    degrees, minutes = self.degrees(deg_abs)

                    if d_sub >= 0:  # 大于正方位
                        now_deg_str = u"{d_big} {degrees}°{minutes}′".format(d_big=d_big, degrees=degrees, minutes=minutes)
                    else:  # 小于正方位
                        now_deg_str = u"{d_small} {degrees}°{minutes}′".format(d_small=d_small, degrees=degrees, minutes=minutes)
                break
        return now_deg_str

    def __str__(self):
        return self.render_dire(self.now_deg)



if __name__ == "__main__":
    import time

    compass = Compass()
    while True:
        compass.update()
        print u"deg:{deg}, deg_str:{deg_str}".format(deg=compass.now_deg, deg_str=compass.now_deg_str)
        time.sleep(0.3)