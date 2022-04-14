clc;
close all;
clear;
timeLimit=0.001;
t1=clock;
problem='TSP';
coord=[1 1;2 3;4 5];
n=size(coord,1);
%假设默认输入n行2列坐标矩阵coord
cx=coord(:,1).';
cy=coord(:,2).';
xi=[];
xj=[];
for k=1:n
    for m=1:n
        xi=[xi k];
        xj=[xj k];
    end
end

dis=zeros(n);   % 初始化两个城市的距离矩阵全为0
for i=2:n    %i从2开始，是因为他与他自己的距离是0
    for j=1:i  
        dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);   % 计算城市i和j的距离
    end
end
dis = dis+dis';   % 生成对称完整的距离矩阵
n1=1:n;
V2=perms(n1);                                %得到全排列遍历矩阵
V2=[V2,V2(:,1)];                            %将第一列放到矩阵最后一列形成环路
V=[];
for k=1:size(V2,1)
    if V2(k,1)==1
        V=[V;V2(k,:)];
    end
end
d=[];
for i=1:size(V,1)                           %计算每一条环路的各段长度
    for j=1:size(V,2)-1
    d(i,j)=dis(V(i,j),V(i,j+1));              %第i种排列情况j城市到j+1城市的距离
    end
end
D=sum(d,2);                                 %将各段长度加和
[d,position]=min(D);                        %找到最短环路
d_min=d;                                    %最短环路的长度
path_min=V(position,:);                     %最短环路的路径          
objVal=d_min;
t2=clock;
t=etime(t2,t1);
if t>timeLimit
    path_min=-1;
    d_min=-1;
    %-1表示程序没跑完
end
Problem.problem=problem;
Problem.n=n;
Problem.cx=cx;
Problem.cy=cy;
Problem.dis=dis;
Problem.xi=xi;
Problem.xj=xj;
Problem.objVal=objVal;
Problem.timeLimit=timeLimit;
