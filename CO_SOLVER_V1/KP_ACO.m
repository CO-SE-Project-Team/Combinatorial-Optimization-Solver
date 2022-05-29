classdef KP_ACO < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
    % SubALGORITHM 继承了 ALGORITHM
    % 父类具有 Data 结构体, 此处无需再次声明、
    % 本类不需要有任何变量
    methods
        % 本类有且仅有以下一种方法/函数
        function solve(obj)
            % 把父类Data中变量赋予该类中你需要使用的变量， 不同问题可能不同
            % 如;

            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';

            capacity=obj.Data.capacity;% 背包的容量
            weight=obj.Data.demand';% 物品的重量
            cx=obj.Data.cx';
            cy=obj.Data.cy';% 物品价值
            n =length(weight);% n为物品的个数
            best_choice=0;
            best_xi=[];
            best_xj=[];

            % 其他变量设置 & 初始化

            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            obj.Data.iterator = 0;
            %% 主要符号说明
            %% C n个物品的坐标，n×2的矩阵
            %% NC_max 最大迭代次数
            %% m 蚂蚁个数
            %% Alpha 表征局部信息素重要程度的参数
            %% Beta 表征启发式因子重要程度的参数
            %% kethe表征全局信息素重要程度的参数
            %% Rho 信息素蒸发系数
            %% Q 当解不稳定时全局信息素增加强度系数
            %% V_best 最终结果
            %% R_best 各代最佳组合
            %% Q_best 各代最佳组合的价值
            %%=========================================================================
            %%第一步：变量初始化
            %C=[55,95;10,4;47,60;5,32;4,23;50,72;8,80;61,62;85,65;87,46];
            %KV=269;
            %C=[44,92;46,4;90,43;72,83;91,84;40,68;75,92;35,82;8,6;54,44;78,32;40,18;77,56;15,83;61,25;17,96;75,70;29,48;75,14;63,58];
            %KV=878;
            %a=[72,490,651,833,883,489,359,337,267,441,70,934,467,661,220,329,440,774,595,98,424,37,807,320,501,309,834,851,34,459,111,253,159,858,793,145,651,856,400,285,405,95,391,19,96,273,152,473,448,231];
            %b=[438,754,699,587,789,912,819,347,511,287,541,784,676,198,572,914,988,4,355,569,144,272,531,556,741,489,321,84,194,483,205,607,399,747,118,651,806,9,607,121,370,999,494,743,967,718,397,589,193,369];
            %KV=11258;
            %b=[350,310,300,295,290,287,283,280,272,270,265,251,230,220,215,212,207,203,202,200,198,196,190,182,181,175,160,155,154,140,132,125,110,105,101,92,83,77,75,73,72,70,69,66,60,58,45,40,38,36,33,31,27,23,20,19,10,9,4,1];
            %a=[135,133,130,11,128,123,20,75,9,66,105,43,18,5,37,90,22,85,9,80,70,17,60,35,57,35,61,40,8,50,32,40,72,35,100,2,7,19,28,10,22,27,30,88,91,47,68,108,10,12,43,11,20,37,17,4,3,21,10,67];
            %KV=3200;
            a=cy;%物品价值
            b=weight;%物品重量
            KV=capacity;
            C=[a,b];
            % n=size(C,1);%n表示问题的规模（物品个数）
            m=n;
            u=n/10;

            D=C(:,1)./C(:,2); %物品价值与重量之比
            D=D';

            V_best=0; %最优价值
            W_best=0; %最优价值对应重量
           
            Eta=zeros(n);
            for i=1:n
                Eta(i) = D(i) ;      %Eta为启发因子，这里设为D
            end
            NC_max=n;
            Alpha=1;
            kethe=1;
            Beta=1;
            Rho=0.3;
            theta=0.7;
            gama=0.15;
            Q=0.1;
            Tau=ones(n);%Tau为局部信息素矩阵
            Tabu=zeros(m,n); %禁忌表矩阵
            ramta=ones(n);%ramta为全局信息素矩阵
            NC=1;%迭代计数器
            Q_best=zeros(NC_max,1); %各代最佳组合的价值
            R_best=zeros(NC_max,n);  %各代最佳组合
            t=ceil(n/3);

            % 开始你的迭代循环
            %obj.is_stop() == false && 
            while(obj.is_stop()==false)
                while (NC < NC_max)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                obj.Data.iterator = obj.Data.iterator + 1;
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                %停止条件之一：达到最大迭代次数
                %%第二步：把贪婪算法的前t个选择赋予禁忌表
                S=zeros(1,m);%每只蚂蚁选择物品总价值
                W=zeros(1,m);%每只蚂蚁选择物品总重量
                for i=1:t
                    Tabu(:,i)=i;%把贪婪算法的前t个选择赋予禁忌表
                end
                %%第三步：m只蚂蚁按概率函数选择下一个物品，完成各自的选择
                for i=1:m
                    for j=1:t
                        if W(i)+b(j)<=KV
                            S(i)=S(i)+a(j); %赋于每只蚂蚁初始价值
                            W(i)=W(i)+b(j); %赋于每只蚂蚁初始重量
                        end
                    end
                end
                for i=1:m
                    for j=(t+1):n
                        puted=Tabu(i,1:(j-1));%已选择的物品
                        Jc=0;
                        for k=(t+1):n
                            if length(find(puted==k))==0
                                if  W(i)+C(k,2)<=KV
                                    Jc=Jc+1;
                                    J(Jc)=k; %目前为止，待选的物品
                                    P=zeros(1,Jc);
                                end
                            end
                        end
                        %下面计算待选物品的概率分布
                        if Jc>0
                            for k=1:Jc
                                P(k)=(theta*Tau(J(k))^Alpha+(1-theta)*ramta(J(k))^kethe)*(Eta(J(k))^Beta);
                            end
                        end
                        P=P/(sum(P));
                        %按概率原则选取下一个物品
                        Pcum=cumsum(P);%元素累加即求和
                        Select=find(Pcum>=rand);%若计算的概率大于随机概率的就选择
                        to_visit=J(Select(1)); %按轮盘赌选取
                        h=0;
                        if  find(puted==to_visit)
                            h=1;
                        end
                        if W(i)+C(to_visit,2)<=KV&&h==0
                            S(i)=S(i)+C(to_visit,1);%蚂蚁价值累加
                            W(i)=W(i)+C(to_visit,2);%蚂蚁重量累加
                            Tabu(i,j)=to_visit;%将选择的物品加入禁忌表
                            if Tabu(i,j-1)>0
                                Tau(to_visit)=(1-Rho).*Tau(to_visit)+u*S(i)/sum(S);%局部信息素更新
                            end
                        end
                    end
                end
                %%第四步：更新信息素
                v=max(S);
                p=find(S==max(S));
                if v>V_best
                    V_best=v;
                    W_best=W(p(1));
                    Q_best(NC)=max(S);
                    pos=find(S==Q_best(NC));
                    R_best(NC,:)=Tabu(pos(1),:);
                else
                    t=t+1;
                    if t > n
                        t = n;
                    end
                    Q_best(NC)=V_best;
                    R_best(NC,:)=Tabu(1,:);
                end
                s=2;
                q=find(S==max(S));
                for i=1:length(q)
                    if s<=n&&Tabu(q(i),s)>0
                        ramta(Tabu(q(i),s))=ramta(Tabu(q(i),s))+u*S(q(i))/sum(S);%全局信息素更新
                        s=s+1;
                    end
                end
                NC=NC+1;

                %%第六步：输出结果
                pos=find(Q_best==V_best);
                Best_choice=R_best(pos(1),:);
%                                 V_best
%                                 W_best
%                                 Best_choice
%                                 X=1:1:NC_max;
%                                 Y=Q_best(X);
%                                 plot(X,Y,'r*',X,Y,'c-.')


                
%                  bbbbb = Best_choice(1, 1:Select);

                xi=[];
                xj=[];
                for i=1:length(Best_choice)
                    if(Best_choice(i)~=0)
                        xi=[xi,Best_choice(i)];
                        xj=[xj,Best_choice(i)];
                    end
                end
                if(length(xi)~=1)
                    xi(length(xi))=[];
                    xj(1)=[];
                end
                obj.Data.xi=xi;
                obj.Data.xj=xj;
                obj.Data.objVal=V_best;
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
                
                if V_best>best_choice
                    best_choice=V_best;
                    best_xi=xi;
                    best_xj=xj;
                end





                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------

                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
            end
            
            obj.Data.xi=best_xi;
            obj.Data.xj=best_xj;
            obj.Data.objVal=best_choice;
            end
            
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