clc
clear all;
combin=fullfact([2 2 2 2 2 2 ])-1;%生成所有的组合可能
v=[20,14,16,16,25,9];%各个点的货物量
c=zeros(length(combin),7);
%第7个点是配送中心
x=[87,91,83,71,64,68,74];
y=[7,38,46,44,60,58,55];
distance=zeros(7,7);
for i=1:7
    distance(i,:)=sqrt((x-x(i)).^2+(y-y(i)).^2);
end
for i=1:64
    q=find(combin(i,:));
    for j=1:64
        qq=find(combin(j,:)==0);
        if length(qq)==length(q)
            if qq==q
               c(i,1)=i;
               c(i,2)=j;
            end
        else
            continue
        end
    end
end%找到对应的安排方案（比如一辆车是123，另一辆车对应是456，删去重复的456，123）
for i=1:64%64是组合可能数
    for j=1:64
        if c(i,1)==c(i,2)+1
            a=i;
        end
    end
end
c=c(a:length(c),:);
bb=[];
dd=[];
for i=1:64
    sum=0;
    for j=1:6
        sum=sum+combin(i,j)*v(j);
    end
    b=find(c(:,2)==i);
    c(b,3)=sum;
    sum1=0;
    for j=1:6
        sum1=sum1+combin(c(b,1),j)*v(j);
    end
    c(b,4)=sum1;
    if sum<=60 & sum1<=60%60是车容量限制
       s=c(b,:);
       bb=[bb;s];
    end
end%此时已经找到了所有满足容量限制的点的集合,存储在bb中
for i=1:length(bb)
    ss=combin(bb(i,1),:);
    for j=1:6
        if ss(j)==1
            ss(j)=j;
        end
    end
    ss(find(ss==0))=[];
    all=perms(ss);
    all_dis=[];
    for j=1:length(all)
        pp=[7,all(j,:),7];
        dis=0;
        for k=1:length(pp)-1
            dis=dis+distance(pp(k),pp(k+1));
        end
        all_dis=[all_dis,dis];
    end
    min_dis=min(all_dis);
    bb(i,5)=min_dis;
    ss1=combin(bb(i,2),:);
    for j=1:6
        if ss1(j)==1
            ss1(j)=j;
        end
    end
    ss1(find(ss1==0))=[];
    al=perms(ss1);
    al_dis1=[];
    for j=1:length(al)
        pp1=[7,al(j,:),7];
        dis1=0;
        for k=1:length(pp1)-1
            dis1=dis1+distance(pp1(k),pp1(k+1));
        end
        al_dis1=[al_dis1,dis1];
    end
    min_dis1=min(al_dis1);
    bb(i,6)=min_dis1;
end
bb(:,7)=bb(:,5)+bb(:,6);
[value,index]=min(bb(:,7));
%第1辆车所行路程
path_long1=bb(index,5);
%第2辆车所行路程
path_long2=bb(index,6);
%%索引路程
%第一条
dianji1=combin(bb(index,1),:);
for i=1:length(dianji1)
    if dianji1(i)==1
        dianji1(i)=i;
    end
end
dianji1(find(dianji1==0))=[];
all_dianji1=perms(dianji1);
for i=1:length(all_dianji1)
    tt=[7,all_dianji1(i,:),7];
    dis=0;
    for k=1:length(tt)-1
        dis=dis+distance(tt(k),tt(k+1));
    end
    if dis==path_long1
        path1=tt;
        break
    end
end
%第二条
dianji2=combin(bb(index,2),:);
for i=1:length(dianji2)
    if dianji2(i)==1
        dianji2(i)=i;
    end
end
dianji2(find(dianji2==0))=[];
all_dianji2=perms(dianji2);
for i=1:length(all_dianji2)
    tt=[7,all_dianji2(i,:),7];
    dis1=0;
    for k=1:length(tt)-1
        dis1=dis1+distance(tt(k),tt(k+1));
    end
    if dis1==path_long2
        path2=tt;
        break
    end
end
disp(['第1辆车行驶路径：',num2str(path1),' ','路程长：',num2str(path_long1)])
disp(['载重为：',num2str(bb(index,3))])
disp(['第2辆车行驶路径：',num2str(path2),' ','路程长：',num2str(path_long2)])
disp(['载重为：',num2str(bb(index,4))])
p=[path1,path2];
x1=[];
y1=[];
for i=1:length(p)
    x1=[x1,x(p(i))];
    y1=[y1,y(p(i))];
end
plot(x1,y1,'b-')
%%补充：bb或者cc中7列分别是第1辆车在combin中对应的索引，第2辆车在combin中对应的索引，第1辆车装载总重，
%%第2辆车装载总重，第1辆车行驶距离，第2辆车行驶距离，两辆车行驶总距离