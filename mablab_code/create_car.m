function [lane,car]=create_car(car_number,lane,length_lane,v_max,length_car)
%% ���쳵������ʼλ���ٶ� x1��x2��ʾ��ͷ��βhλ�� y��ʾ����
  car=struct('v',zeros(1,car_number),'x1',zeros(1,car_number),'x2',zeros(1,car_number),'y',zeros(1,car_number));
for id=1:car_number
    car.y(id)=1;
% ���������ȷ����ͷλ�ã��ٸ��ݳ���ȷ����βλ��
% �����������Ա߽磬��������һ�����ڵ�·�߽���ʱ����β���궨Ϊ1
    car.x1(id) = fix( 1+rand(1)*(length_lane-1));
    car.x2(id)=max(car.x1(id)-length_car+1,1); 
% ���ڴ����ĳ�ͷ����β��Χ��������Ԫ���ѱ�֮ǰ�����ĳ���ռ�ã��������²������λ��
    while any(lane(car.y(id),car.x2(id):car.x1(id)))
        car.x1(id)=fix( 1+rand(1)*(length_lane-1) );
        car.x2(id)=max(car.x1(id)-length_car+1,1);
    end
% �����������İ���ֵ-1 �������ٶ�
    lane(car.y(id),car.x2(id):car.x1(id)) = -1;
    car.v(id)=randi([0 v_max]);
end
end
