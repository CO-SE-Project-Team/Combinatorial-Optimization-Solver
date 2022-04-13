clc;
close all;
clear;
C=[0,3,6,7;5,0,2,3;6,4,0,2;3,7,5,0];        %输入距离矩阵
n=1:size(C,1);
V2=perms(n);                                %得到全排列遍历矩阵
V2=[V2,V2(:,1)];                            %将第一列放到矩阵最后一列形成环路
V=[];
for k=1:size(V2,1)
    if V2(k,1)==1
        V=[V;V2(k,:)];
    end
end
for i=1:size(V,1)                           %计算每一条环路的各段长度
    for j=1:size(V,2)-1
    d(i,j)=C(V(i,j),V(i,j+1));              %第i种排列情况j城市到j+1城市的距离
    end
end
D=sum(d,2);                                 %将各段长度加和
[d,position]=min(D);                        %找到最短环路
d_min=d;                                    %最短环路的长度
path_min=V(position,:);                     %最短环路的路径                    
N=length(path_min);
p = num2str(path_min(1));                   %将路径加上->
for i=2:N
    p=[p,'->',num2str(path_min(i))];
end
disp('深度遍历优先算法DFS得到的最优路径为:')
disp(p)
fprintf('深度遍历优先算法DFS得到的最优路径的长度为:%d\n',d_min)