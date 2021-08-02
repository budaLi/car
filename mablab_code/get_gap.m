function [gap,car_front_v]=get_gap(lane,car,length_lane,car_number)
%% ���ÿһ��id��Ӧ�ĳ���ǰ���ļ�� ������gap����ÿ����Ӧ���� ��ǰ���ٶ�
gap=zeros(1,car_number);
car_front_v=zeros(1,car_number);
for id=1:car_number
   %����׳�
    leadcar=1;
    %�жϵ��߽��Ƿ���ڳ��� ���� �����ǰ����� ����Ƿ��׳�
    for front = ( car.x1(id) + 1 ):length_lane
        if lane(car.y(id),front)~=0
            car_front_v(1,id)=car.v(car.x2==front & car.y==car.y(id));
            leadcar=0;
            break
        end
    end
    if leadcar==0    %�׳������� δ�ﵽ�߽����� ����
        gap(id)=front-car.x1(id)-1;
    else
    %  ��ѭ�� ���׳� ��ִ���������� ���㵽��һ�����ļ��
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
