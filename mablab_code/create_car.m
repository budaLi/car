function [lane,car]=create_car(car_number,lane,length_lane,v_max,length_car)
%% 创造车辆及初始位置速度 x1和x2表示车头车尾h位置 y表示车道
  car=struct('v',zeros(1,car_number),'x1',zeros(1,car_number),'x2',zeros(1,car_number),'y',zeros(1,car_number));
for id=1:car_number
    car.y(id)=1;
% 先用随机数确定车头位置，再根据车长确定车尾位置
% 由于是周期性边界，故若车有一部分在道路边界外时，车尾坐标定为1
    car.x1(id) = fix( 1+rand(1)*(length_lane-1));
    car.x2(id)=max(car.x1(id)-length_car+1,1); 
% 若在创建的车头至车尾范围内有任意元胞已被之前创立的车辆占用，则需重新产生随机位置
    while any(lane(car.y(id),car.x2(id):car.x1(id)))
        car.x1(id)=fix( 1+rand(1)*(length_lane-1) );
        car.x2(id)=max(car.x1(id)-length_car+1,1);
    end
% 将产生车辆的胞赋值-1 并赋初速度
    lane(car.y(id),car.x2(id):car.x1(id)) = -1;
    car.v(id)=randi([0 v_max]);
end
end
