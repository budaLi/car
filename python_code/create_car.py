# Generated with SMOP  0.41
from smop.libsmop import *
# create_car.m
from random import randint
import numpy as np


def create_car(car_number=None, lane=None, length_lane=None, v_max=None, length_car=None, *args, **kwargs):
    # varargin = create_car.varargin
    # nargin = create_car.nargin
    # 设置道路参数
    W = 1
    ## 创造车辆及初始位置速度 x1和x2表示车头车尾h位置 y表示车道

    car = struct('v', np.zeros((W,car_number)), 'x1', np.zeros((W,car_number)), 'x2', np.zeros((W,car_number)), 'y',
                 np.zeros((W,car_number)))

    # 为每一辆车随机分配位置
    for index in range(1, car_number):

        # TODO 因为是1车道 所以这里暂时为1  后续多车道时需要相应更改
        car.y[index] = 1
        # 先用随机数确定车头位置，再根据车长确定车尾位置
        # 由于是周期性边界，故若车有一部分在道路边界外时，车尾坐标定为1

        # 车头的位置可随机
        car.x1[index] = randint(0,length_lane-1)
        # TODO 假设车尾为车头+1
        car.x2[index] = car.x1[index]+1
        # 若在创建的车头至车尾范围内有任意元胞已被之前创立的车辆占用，则需重新产生随机位置
        while any(lane[car.y[index],car.x1(index):car.x2(index)]):
            car.x1[index] = np.rint(1 + dot(rand(1), (length_lane - 1)))
            # TODO 假设车尾为车头+1
            car.x2[index] = car.x1[index]+1

        # 将产生车辆的胞赋值-1 并赋初速度
        lane[car.y[index], car.x1[index], car.x2[index]] = - 1

        car.v[index] = randint(0, v_max)

    return lane, car


if __name__ == '__main__':
    pass
