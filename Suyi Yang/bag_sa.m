clear
clc
a = 0.95;
cy = [6;3;5;4;6];        %价值
cy = -cy;         %模拟退火算法是求解最小值，故取负值
weight = [2;2;6;5;4];          %质量
capacity = 10;
n = 5;
sol_new = ones(1,n);          %生成初始解
E_current = inf;
E_best = inf;
%E_current是当前解对应的目标函数值（即背包中物品总价值）
%E_new是新解的目标函数值
%E_best是最优解
sol_current = sol_new;
sol_best = sol_new;
t0 = 97;
tf = 3;
t = t0;
p = 1;

while t >= tf
    for r = 1:100
        %产生随机扰动
        tmp = ceil(rand*n);
        sol_new(1,tmp) = ~sol_new(1,tmp);
        %检查是否满足约束
        while 1
            q = (sol_new * weight <= capacity);
            if ~q
                p = ~p;             %实现交错着逆转头尾的第一个1
                tmp = find(sol_new == 1);
                if p
                    sol_new(1,tmp(1)) = 0;
                else
                    sol_new(1,tmp(end)) = 0;
                end
            else
                break
            end
        end
        
        %计算背包中的物品价值
        E_new = sol_new * cy;
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            if rand < exp( -(E_new - E_current) / t)
                E_current = E_new;
                sol_surrent = sol_new;
            else
                sol_new = sol_current;
            end
        end
    end
    t = t * a;
end

disp('最优解为:');
sol_best
disp('物品总价值等于:');
val = -E_best;
disp(val);
disp('背包中物品重量是:');
disp(sol_best * weight);
% ————————————————
% 版权声明：本文为CSDN博主「WangYutao1995」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
% 原文链接：https://blog.csdn.net/kirisame9/article/details/79891450