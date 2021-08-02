function [lane,car,car_a]=move_forward(lane,length_lane,car,length_car,car_number,car_a,v_max,gap,car_front_v,p_slow,p_start_car,p_dec,p_a1,p_a2,v_syn,delta_v_syn,v_pinch,k1,k2)
for id=1:car_number            
    %% 更新前工作
    lane(car.y(id),car.x2(id):car.x1(id))=0;
    % 记录下变化前车速
    v_n=car.v(id);
    r=rand();
    %% 同步流车距
    if v_n>v_pinch
        G=k1*v_n;
    else
        G=k2*v_n;
    end
    %% 速度适配
    % 概率计算 过度加速
    p_a=p_a1+p_a2*max(0,min(1,(v_n-v_syn)/delta_v_syn));
    if gap(id)<=G
         car.v(id)=v_n+sign(car_front_v(id)-v_n);
        if v_n>=car_front_v(id) && r<p_a
            car.v(id)=min(car.v(id)+1,v_max);
        end
    else
        car.v(id)=min(v_n+1,v_max);
    end
    %% 判断前进的速度与车距 减速
    car.v(id)=min([v_max,gap(id),car.v(id)]);
    %% 随机慢化和慢启动
    % 确定概率p取值
    if car.v(id)>v_n
        if v_n==0
            p=p_start_car;
        else
            if car_a(id)>0
                p=0;
            else
                p=p_dec;
            end
        end
    else
        p=p_slow;
    end
    %% 慢化
    if p_a<=r<p_a+p   
        car.v(id)=max(0,car.v(id)-1);
    end
    %% 记录速度变化情况
    car_a(id)=car.v(id)-v_n;
    %% 位置更新
    car.x1(id)=fix(mod(car.x1(id)+car.v(id)-1,length_lane)+1);
    car.x2(id)=max(car.x1(id)-length_car+1,1);
    lane(car.y(id),car.x2(id):car.x1(id))=-1;
end
end
