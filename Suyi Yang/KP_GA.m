classdef KP_GA < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';
            best_choice=0;
            best_xi=[];
            best_xj=[];

            capacity=obj.Data.capacity;% 背包的容量
            weight=obj.Data.demand';% 物品的重量
            cx=obj.Data.cx';
            cy=obj.Data.cy';% 物品价值
            n =length(weight);% n为物品的个数
            p1 = .95; %交叉概率
            p2 = .15; %变异概率
            
            %构建初始种群 
            zhongqun_nums = 14;
            jiyin = zeros(1,n);
            
            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            zhongqun1 = zeros(zhongqun_nums,n);
            ave_value = zeros(1,iterations);
            max_value = zeros(1,iterations);
            for i = 1:zhongqun_nums
                jiyin = round(rand(1,n));
                while jiyin * weight> capacity
                    jiyin = round(rand(1,n));
                end
                zhongqun1(i,:) = jiyin;
            end
            % 开始你的迭代循环
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                xi=[];
                xj=[];
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
                        if temp1 * weight<= capacity && temp2 * weight  <= capacity
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
                        if  temp * weight<= capacity
                            zhongqun3(k,:) = temp;
                        end
                    end
                end
                %选择 
                % 价值最大的前zhongqun_nums个
                zhongqun = [zhongqun1;zhongqun2;zhongqun3];
                temp_value = zhongqun*(cy);
                [~,index] = sort(temp_value,'descend');
                ave_value(i) = sum(zhongqun(index(1:zhongqun_nums),:)*cy)/zhongqun_nums;
                max_value(i) = zhongqun(index(1),:)*cy;
                zhongqun1 = zhongqun(index(1:zhongqun_nums),:);
                v=zhongqun(1,:);
                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------
                        
                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
                for i=1:n
                    if v(i)==1
                        xi=[xi,cx(i)];
                        xj=[xj,cx(i)];
                    end
                end
                l=length(xi);
                if(l>1)
                    xi(l)=[];
                    xj(1)=[];
                end
    
                
                obj.Data.xi=xi;
                obj.Data.xj=xj;
                obj.Data.objVal=zhongqun(1,:)*cy;
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
                % 当前迭代数加一，方便父类is_stop()检查是否超过iterations并停止算法
                obj.Data.iterator = obj.Data.iterator + 1;
                if zhongqun(1,:)*cy>best_choice
                    best_choice=zhongqun(1,:)*cy;
                    best_xi=xi;
                    best_xj=xj;
                end
            end
            
            obj.Data.xi=best_xi;
            obj.Data.xj=best_xj;
            obj.Data.objVal=best_choice;
        end
    end
end

%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次