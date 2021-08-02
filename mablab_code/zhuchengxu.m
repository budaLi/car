%% 设置道路参数
W=1;
length_lane=2000; % 3km
lane=zeros(W,length_lane);
per_cell=1.5;
per=(length_lane*per_cell)/1000;
q=55;
%% 迭代次数
iteraction=2000;  
start_time=1000; 
period=iteraction-start_time; %取最后30秒
%% 设置车辆参数
% 设置客车参数
v_max=11;
length_car=5;
%% 同步流参数
v_pinch=7;
k1=2;
k2=1;
%% 慢启动和随机慢化参数
p_start_car=0.1;
p_slow=0.01;
%% KKSW over_acc单车道上随机加速参数
p_a1=0.07;
p_a2=0.08;
p_dec=0.05;
v_syn=8;
delta_v_syn=3;
%% 更新车辆数
car_number=per*q;
%% 在车道随机投放车辆
[lane,car]=create_car(car_number,lane,length_lane,v_max,length_car);
%% 时空图
memor_car=zeros(2,period,car_number);
car_a=zeros(1,car_number);
%% 主函数 车辆运动
for t=1:iteraction
    %% 进入时间段时开始时空图数据
        if t>start_time
        memor_car(1,t-start_time,:)=car.x1;
        memor_car(2,t-start_time,:)=car.v;
        end
    % 当前车道前车速度 和 目标车道的前后车距和速度
     [gap,car_front_v]=get_gap(lane,car,length_lane,car_number);
    %% 移动
     [lane,car,car_a]=move_forward(lane,length_lane,car,length_car,car_number,car_a,v_max,gap,car_front_v,p_slow,p_start_car,p_dec,p_a1,p_a2,v_syn,delta_v_syn,v_pinch,k1,k2);
end
%% 
T=(start_time+1:iteraction);
figure(2)
for id=1:car_number
   %时空图与速度联系
   scatter(T,memor_car(1,:,id),5,memor_car(2,:,id),'filled');
    hold on;
end
colorbar
colormap(copper);
xlabel('time');
ylabel('position');
axis([start_time iteraction 1 length_lane]);
caxis([0 v_max]);
figure(3)
start_time_trace=1850
%% 由于之前已记录了车辆i对应的坐标变化 因此做轨迹图循环每辆车再用plot将每个时刻坐标连起来即可
%% 需要注意的是周期性边界车辆开出边界也连线 因此要在走到末端时断开连线
for id=1:car_number
       t_out=start_time_trace+1;  % 标记每次驶出边界的时刻
   for t=start_time_trace+1:iteraction
       if memor_car(1,t-start_time_trace,id)>length_lane-v_max
            plot(t_out:t,memor_car(1,t_out-start_time_trace:t-start_time_trace,id),'-k');
            hold on;
            t_out=t+1; % 标记下一次开始的起始时刻
       end
   end
   plot(t_out:iteraction,memor_car(2,t_out-start_time_trace:iteraction-start_time_trace,id),'-k'); % 若最后一次没达到终点 需再画一次
   hold on;
end
xlabel('position');
ylabel('time');
title('轨迹图');
axis([start_time_trace+1 iteraction 1000 length_lane]);

