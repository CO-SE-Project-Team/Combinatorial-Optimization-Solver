classdef KP_VNS < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';

            capacity=obj.Data.capacity;% 背包的容量
            weight=obj.Data.demand;% 物品的重量
            cx=obj.Data.cx;
            cy=obj.Data.cy;% 物品价值
            n =length(weight);% n为物品的个数
            best_choice=0;
            best_xi=[];
            best_xj=[];
            optv=[];
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                xi=[];
                xj=[];
                objVal=0;%被选择物品的总价值
                v=dec2bin(randi([0 2^n-1]),n);
                selections=[];
                for i=1:n
                    selections(1,i)=str2num(v(i));
                end
                num=1;
                for i=1:n
                    vi=v;
                    if(vi(i)=='1')
                        vi(i)='0';
                    else
                        vi(i)='1';
                    end
                    num=num+1;
                    for m=1:n
                        selections(num,m)=str2num(vi(m));
                    end
                    if(n>1)
                        for j=(i+1):n
                            vj=vi;
                            if(vj(j)=='1')
                                vj(j)='0';
                            else
                                vj(j)='1';
                            end
                            num=num+1;
                            for m=1:n
                                selections(num,m)=str2num(vj(m));
                            end
                            if(n>3)
                                vk=vj;
                                if(i>3)
                                    c=vk(i);
                                    vk(i)=vk(i-3);
                                    vk(i-3)=c;
                                else
                                    c=vk(i);
                                    vk(n-i)=vk(i);
                                    vk(n-i)=c;
                                end
                                num=num+1;
                                for m=1:n
                                    selections(num,m)=str2num(vk(m));
                                end
                            end
                        end
                    end
                end
                for i=1:num
                    vi=selections(i,:);
                    temp_w=0;
                    temp_p=0;
                    for j=1:n
                        if vi(j)==1
                            temp_w=temp_w+weight(j);
                            temp_p=temp_p+cy(j);
                        end
                    end
                    if (temp_w<=capacity)&&(temp_p>objVal)
                        objVal=temp_p;
                        optv=vi;
                    end
                end
                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------
                        
                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
                for i=1:n
                    if optv(i)==1
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
                obj.Data.objVal=objVal;
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
                % 当前迭代数加一，方便父类is_stop()检查是否超过iterations并停止算法
                obj.Data.iterator = obj.Data.iterator + 1;
                if objVal>best_choice
                    best_choice=objVal;
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