classdef KP_DP < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';

            capacity=obj.Data.capacity;% 背包的容量
            weight=[0,obj.Data.demand];% 物品的重量
            cx=[0,obj.Data.cx];
            cy=[0,obj.Data.cy];% 物品价值
            n =length(weight);% n为物品的个数
            V=[];%定义状态转移矩阵存储选中物品总价值
            objVal=0;%被选择物品的总价值
            v=[];
            xi=[];
            xj=[];

            obj.start_clock();

            for j=1:(capacity+1)
                    if weight(n)<j
                            V(n,j)=cy(n) ;
                    else
                            V(n,j)=0;
                    end
            end
            
            %判断下一个物品是放还是不放；不放时：F[i,v]=F[i-1,v]；放时：F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+w_i}；
            for i=n-1:-1:1
                    for j=1:(capacity+1)
                            if j<=weight(i)
                                    V(i,j)=V(i+1,j);
                            else
                                    if V(i+1,j)>V(i+1,j-weight(i))+cy(i)
                                            V(i,j)=V(i+1,j);
                                    else
                                            V(i,j)=V(i+1,j-weight(i))+cy(i);
                                    end
                            end
                    end
            end
            
            %输出被选择的物品。
            i=capacity;
            for j=1:n-1
                    if V(j,i)==V(j+1,i)
                            v(j)=0;
                    else
                            v(j)=1;
                            i=i-weight(j);
                    end
            end
            if V(n,i)==0
                    v(n)=0;
            else
                    v(n)=1;
                    
            end
            
            %计算被选择物品的总价值
            for i=2:n
                if(v(i)==1)
                    objVal=objVal+cy(i);
                end
            end
            
            if obj.is_stop()==true
                objVal=-1;
                %-1表示程序没跑完
            end
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
            cx(1)=[];
            cy(1)=[];
            weight(1)=[];

            obj.Data.problem=problem;
            obj.Data.n=n-1;
            obj.Data.capacity=capacity;
            obj.Data.demand=weight;
            obj.Data.cx=cx;
            obj.Data.cy=cy;
            obj.Data.dis=0;
            obj.Data.xi=xi;
            obj.Data.xj=xj;
            obj.Data.objVal=objVal;
            obj.Data.timeLim=timeLim;
            obj.Data.iterations=iterations;
            obj.Data.iterator=iterator;
            obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
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