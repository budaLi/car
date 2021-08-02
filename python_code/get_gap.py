# Generated with SMOP  0.41
from smop.libsmop import *



def get_gap(lane=None, car=None, length_lane=None, car_number=None, *args, **kwargs):
    varargin = get_gap.varargin
    nargin = get_gap.nargin
    gap = zeros(1, car_number)
    car_front_v = zeros(1, car_number)
    for id in arange(1, car_number).reshape(-1):
        leadcar = 1
        for front in arange((car.x1(id) + 1), length_lane).reshape(-1):
            if lane(car.y(id), front) != 0:
                car_front_v[1, id] = car.v(car.x2 == logical_and(front, car.y) == car.y(id))
                leadcar = 0
                break
        if leadcar == 0:
            gap[id] = front - car.x1(id) - 1
        else:
            for front_lead in arange(1, car.x2(id)).reshape(-1):
                if lane(car.y(id), front_lead) != 0:
                    car_front_v[1, id] = car.v(car.x2 == logical_and(front_lead, car.y) == car.y(id))
                    break
            gap[id] = length_lane - (car.x1(id) - front_lead) - 1

    return gap, car_front_v


if __name__ == '__main__':
    pass
