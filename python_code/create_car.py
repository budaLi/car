# Generated with SMOP  0.41
from smop.libsmop import *
# create_car.m
from random import randint
import numpy as np


def create_car(car_number=None, lane=None, length_lane=None, v_max=None, length_car=None, *args, **kwargs):
    # varargin = create_car.varargin
    # nargin = create_car.nargin
    # ���õ�·����
    W = 1
    ## ���쳵������ʼλ���ٶ� x1��x2��ʾ��ͷ��βhλ�� y��ʾ����

    car = struct('v', np.zeros((W,car_number)), 'x1', np.zeros((W,car_number)), 'x2', np.zeros((W,car_number)), 'y',
                 np.zeros((W,car_number)))

    # Ϊÿһ�����������λ��
    for index in range(1, car_number):

        # TODO ��Ϊ��1���� ����������ʱΪ1  �����೵��ʱ��Ҫ��Ӧ����
        car.y[index] = 1
        # ���������ȷ����ͷλ�ã��ٸ��ݳ���ȷ����βλ��
        # �����������Ա߽磬��������һ�����ڵ�·�߽���ʱ����β���궨Ϊ1

        # ��ͷ��λ�ÿ����
        car.x1[index] = randint(0,length_lane-1)
        # TODO ���賵βΪ��ͷ+1
        car.x2[index] = car.x1[index]+1
        # ���ڴ����ĳ�ͷ����β��Χ��������Ԫ���ѱ�֮ǰ�����ĳ���ռ�ã��������²������λ��
        while any(lane[car.y[index],car.x1(index):car.x2(index)]):
            car.x1[index] = np.rint(1 + dot(rand(1), (length_lane - 1)))
            # TODO ���賵βΪ��ͷ+1
            car.x2[index] = car.x1[index]+1

        # �����������İ���ֵ-1 �������ٶ�
        lane[car.y[index], car.x1[index], car.x2[index]] = - 1

        car.v[index] = randint(0, v_max)

    return lane, car


if __name__ == '__main__':
    pass
