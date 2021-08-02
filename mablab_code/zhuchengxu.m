%% ���õ�·����
W=1;
length_lane=2000; % 3km
lane=zeros(W,length_lane);
per_cell=1.5;
per=(length_lane*per_cell)/1000;
q=55;
%% ��������
iteraction=2000;  
start_time=1000; 
period=iteraction-start_time; %ȡ���30��
%% ���ó�������
% ���ÿͳ�����
v_max=11;
length_car=5;
%% ͬ��������
v_pinch=7;
k1=2;
k2=1;
%% �������������������
p_start_car=0.1;
p_slow=0.01;
%% KKSW over_acc��������������ٲ���
p_a1=0.07;
p_a2=0.08;
p_dec=0.05;
v_syn=8;
delta_v_syn=3;
%% ���³�����
car_number=per*q;
%% �ڳ������Ͷ�ų���
[lane,car]=create_car(car_number,lane,length_lane,v_max,length_car);
%% ʱ��ͼ
memor_car=zeros(2,period,car_number);
car_a=zeros(1,car_number);
%% ������ �����˶�
for t=1:iteraction
    %% ����ʱ���ʱ��ʼʱ��ͼ����
        if t>start_time
        memor_car(1,t-start_time,:)=car.x1;
        memor_car(2,t-start_time,:)=car.v;
        end
    % ��ǰ����ǰ���ٶ� �� Ŀ�공����ǰ�󳵾���ٶ�
     [gap,car_front_v]=get_gap(lane,car,length_lane,car_number);
    %% �ƶ�
     [lane,car,car_a]=move_forward(lane,length_lane,car,length_car,car_number,car_a,v_max,gap,car_front_v,p_slow,p_start_car,p_dec,p_a1,p_a2,v_syn,delta_v_syn,v_pinch,k1,k2);
end
%% 
T=(start_time+1:iteraction);
figure(2)
for id=1:car_number
   %ʱ��ͼ���ٶ���ϵ
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
%% ����֮ǰ�Ѽ�¼�˳���i��Ӧ������仯 ������켣ͼѭ��ÿ��������plot��ÿ��ʱ����������������
%% ��Ҫע����������Ա߽糵�������߽�Ҳ���� ���Ҫ���ߵ�ĩ��ʱ�Ͽ�����
for id=1:car_number
       t_out=start_time_trace+1;  % ���ÿ��ʻ���߽��ʱ��
   for t=start_time_trace+1:iteraction
       if memor_car(1,t-start_time_trace,id)>length_lane-v_max
            plot(t_out:t,memor_car(1,t_out-start_time_trace:t-start_time_trace,id),'-k');
            hold on;
            t_out=t+1; % �����һ�ο�ʼ����ʼʱ��
       end
   end
   plot(t_out:iteraction,memor_car(2,t_out-start_time_trace:iteraction-start_time_trace,id),'-k'); % �����һ��û�ﵽ�յ� ���ٻ�һ��
   hold on;
end
xlabel('position');
ylabel('time');
title('�켣ͼ');
axis([start_time_trace+1 iteraction 1000 length_lane]);

