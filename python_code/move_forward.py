# Generated with SMOP  0.41
from smop.libsmop import *
# move_forward.m

import numpy as np


@function
def move_forward(lane=None, length_lane=None, car=None, length_car=None, car_number=None, car_a=None, v_max=None,
                 gap=None, car_front_v=None, p_slow=None, p_start_car=None, p_dec=None, p_a1=None, p_a2=None,
                 v_syn=None, delta_v_syn=None, v_pinch=None, k1=None, k2=None, *args, **kwargs):
    varargin = move_forward.varargin
    nargin = move_forward.nargin

    for id in arange(1, car_number).reshape(-1):
        ## 更新前工作
        lane[car.y(id), arange(car.x2(id), car.x1(id))] = 0
        v_n = car.v(id)
        r = rand()
        if v_n > v_pinch:
            G = dot(k1, v_n)
        else:
            G = dot(k2, v_n)
        ## 速度适配
        # 概率计算 过度加速
        p_a = p_a1 + dot(p_a2, max(0, min(1, (v_n - v_syn) / delta_v_syn)))
        if gap(id) <= G:
            car.v[id] = v_n + np.sign(car_front_v(id) - v_n)
            if v_n >= car_front_v(id) and r < p_a:
                car.v[id] = min(car.v(id) + 1, v_max)
        else:
            car.v[id] = min(v_n + 1, v_max)
        ## 判断前进的速度与车距 减速
        car.v[id] = min(concat([v_max, gap(id), car.v(id)]))
        # 确定概率p取值
        if car.v(id) > v_n:
            if v_n == 0:
                p = copy(p_start_car)
            else:
                if car_a(id) > 0:
                    p = 0
                else:
                    p = copy(p_dec)
        else:
            p = copy(p_slow)
        ## 慢化
        if p_a <= r < p_a + p:
            car.v[id] = max(0, car.v(id) - 1)
        ## 记录速度变化情况
        car_a[id] = car.v(id) - v_n
        car.x1[id] = fix(mod(car.x1(id) + car.v(id) - 1, length_lane) + 1)
        car.x2[id] = max(car.x1(id) - length_car + 1, 1)
        lane[car.y(id), arange(car.x2(id), car.x1(id))] = - 1

    return lane, car, car_a


if __name__ == '__main__':
    pass
