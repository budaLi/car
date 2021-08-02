# coding:utf-8
# Generated with SMOP  0.41
# from smop.libsmop import *

from numpy import zeros,dot
from create_car import create_car
from get_gap import get_gap
from move_forward import move_forward

# 设置道路参数
W = 1
length_lane = 2000

# 道路宽和长度的一个矩阵  可用来存放车辆信息
lane = zeros((W, length_lane))
per_cell = 1.5
per = (dot(length_lane, per_cell)) / 1000
q = 55
## 迭代次数
iteraction = 2000
start_time = 1000
period = iteraction - start_time

## 设置车辆参数
# 设置客车参数
v_max = 11   # 车辆最大速度
length_car = 5
## 同步流参数
v_pinch = 7
k1 = 2
k2 = 1
## 慢启动和随机慢化参数
p_start_car = 0.1
p_slow = 0.01
## KKSW over_acc单车道上随机加速参数
p_a1 = 0.07
p_a2 = 0.08
p_dec = 0.05
v_syn = 8
delta_v_syn = 3
## 更新车辆数
car_number = int(dot(per, q))
## 在车道随机投放车辆
lane, car = create_car(car_number, lane, length_lane, v_max, length_car, nargout=2)
## 时空图
memor_car = zeros(2, period, car_number)
car_a = zeros(1, car_number)
## 主函数 车辆运动
for t in range(1,iteraction):
    ## 进入时间段时开始时空图数据
    if t > start_time:
        memor_car[1, t - start_time, arange()] = car.x1
        memor_car[2, t - start_time, arange()] = car.v
    # 当前车道前车速度 和 目标车道的前后车距和速度
    gap, car_front_v = get_gap(lane, car, length_lane, car_number, nargout=2)
    lane, car, car_a = move_forward(lane, length_lane, car, length_car, car_number, car_a, v_max, gap, car_front_v,
                                    p_slow, p_start_car, p_dec, p_a1, p_a2, v_syn, delta_v_syn, v_pinch, k1, k2,
                                    nargout=3)

    T = (arange(start_time + 1, iteraction))
    # zhuchengxu.m:49
    # figure(2)
    # for id in arange(1, car_number).reshape(-1):
    #     # 时空图与速度联系
    #     scatter(T, memor_car(1, arange(), id), 5, memor_car(2, arange(), id), 'filled')
    #     hold('on')
    #
    # colorbar
    # colormap(copper)
    # xlabel('time')
    # ylabel('position')
    # axis(concat([start_time, iteraction, 1, length_lane]))
    # caxis(concat([0, v_max]))
    # figure(3)
    # start_time_trace = 1850
    # # zhuchengxu.m:63
    # ## 由于之前已记录了车辆i对应的坐标变化 因此做轨迹图循环每辆车再用plot将每个时刻坐标连起来即可
    # ## 需要注意的是周期性边界车辆开出边界也连线 因此要在走到末端时断开连线
    # for id in arange(1, car_number).reshape(-1):
    #     t_out = start_time_trace + 1
    #     # zhuchengxu.m:67
    #     for t in arange(start_time_trace + 1, iteraction).reshape(-1):
    #         if memor_car(1, t - start_time_trace, id) > length_lane - v_max:
    #             plot(arange(t_out, t), memor_car(1, arange(t_out - start_time_trace, t - start_time_trace), id), '-k')
    #             hold('on')
    #             t_out = t + 1
    #     # zhuchengxu.m:72
    #     plot(arange(t_out, iteraction),
    #          memor_car(2, arange(t_out - start_time_trace, iteraction - start_time_trace), id), '-k')
    #     hold('on')
    #
    # xlabel('position')
    # ylabel('time')
    # title('轨迹图')
    # axis(concat([start_time_trace + 1, iteraction, 1000, length_lane]))
