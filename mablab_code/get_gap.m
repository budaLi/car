function [gap,car_front_v]=get_gap(lane,car,length_lane,car_number)
%% 算出每一个id对应的车与前车的间距 用数组gap储存每组相应数据 和前车速度
gap=zeros(1,car_number);
car_front_v=zeros(1,car_number);
for id=1:car_number
   %标记首车
    leadcar=1;
    %判断到边界是否存在车辆 若是 算出与前车间距 并标记非首车
    for front = ( car.x1(id) + 1 ):length_lane
        if lane(car.y(id),front)~=0
            car_front_v(1,id)=car.v(car.x2==front & car.y==car.y(id));
            leadcar=0;
            break
        end
    end
    if leadcar==0    %首车的类型 未达到边界的情况 求间距
        gap(id)=front-car.x1(id)-1;
    else
    %  若循环 非首车 则执行下列条件 计算到第一辆车的间距
        for front_lead=1:car.x2(id)
            if lane(car.y(id),front_lead)~=0
                    car_front_v(1,id)=car.v(car.x2==front_lead & car.y==car.y(id));    
                break
            end
        end
            gap(id)=length_lane-(car.x1(id)-front_lead)-1;
    end  
end
end
