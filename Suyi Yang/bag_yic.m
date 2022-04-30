close;
clear;
clc

% 背包问题 运用遗传算法
weight = [2 2 6 5 4];
price = [6 3 5 4 6];

n = length(weight);
p1 = .95; %交叉概率
p2 = .15; %变异概率
max_diedai = 50; %最大迭代次数

%构建初始种群 
zhongqun_nums = 14;
Capacity = 10; % 背包最大承重
jiyin = zeros(1,n);

rand('state',sum(clock));
zhongqun1 = zeros(zhongqun_nums,n);
ave_value = zeros(1,max_diedai);
max_value = zeros(1,max_diedai);
for i = 1:zhongqun_nums
    jiyin = round(rand(1,n));
    while jiyin * weight' > Capacity
        jiyin = round(rand(1,n));
    end
    zhongqun1(i,:) = jiyin;
end
tic
for i = 1: max_diedai
    %交叉：单点
    zhongqun2 = zhongqun1;
    for k = 1: 2 : zhongqun_nums
        if rand < p1 %判断是否交叉
            pos = ceil(n*rand); %交叉位置
            temp1 = zhongqun2(k,:);
            temp2 = zhongqun2(k+1,:);
            temp = temp1(pos);
            temp1(pos) = temp2(pos);
            temp2(pos) = temp;
            if temp1 * weight' <= Capacity && temp2 * weight'  <= Capacity
                zhongqun2(k,:) = temp1;
                zhongqun2(k+1,:) = temp2;
            end
        end
    end
        %变异
        zhongqun3 = zhongqun1; %与交叉同等地位
        for k = 1:zhongqun_nums
            if rand < p2
                pos = ceil(n*rand);
                temp = zhongqun3(k,:);
                temp(pos) = ~temp(pos);
                if  temp * weight' <= Capacity
                    zhongqun3(k,:) = temp;
                end
            end
        end
        %选择 
        % 价值最大的前zhongqun_nums个
        zhongqun = [zhongqun1;zhongqun2;zhongqun3];
        temp_value = zhongqun*(price');
        [t,index] = sort(temp_value,'descend');
        ave_value(i) = sum(zhongqun(index(1:zhongqun_nums),:)*price')/zhongqun_nums;
        max_value(i) = zhongqun(index(1),:)*price';
        zhongqun1 = zhongqun(index(1:zhongqun_nums),:);
end
% 
% disp('选择方式：')
% disp(zhongqun(1,:))
% disp('最大价值：')
% disp(zhongqun(1,:)*price')
% disp('最大重量：')
% disp(zhongqun(1,:)*weight')

s=zhongqun(1,:)*price';
s

% plot(ave_value,'-dr');
% ylabel('平均价值');
% xlabel('迭代周期');
% figure
% plot(max_value,'-ro');
% ylabel('最大价值');
% xlabel('迭代周期');
% ————————————————
% 版权声明：本文为CSDN博主「一夜星尘」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
% 原文链接：https://blog.csdn.net/weixin_43914658/article/details/108610906