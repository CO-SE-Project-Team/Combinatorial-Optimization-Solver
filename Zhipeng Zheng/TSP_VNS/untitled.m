


A=[50 19 49 49 53 85 33 59 33 82 70;50 16 92 30 42 90 74 32 23 59 41;0 1.15 1.34 0.53 1.79 1.47 0.01 0.95 0.26 1.21 0.69]; 
rong=3;  
m=size(A,2);
c=zeros(m,m);
for j=1:m                                                     
    for i=(j+1):m
        c(i,j)=sqrt((A(1,i)-A(1,j))^2+(A(2,i)-A(2,j))^2);
    end
end
 
p=zeros(m-1,m-1);
for j=2:(m-1)                                                 
    for i=(j+1):m
        p(i-1,j-1)=c(i,1)+c(j,1)-c(i,j);
    end
end
 
s=p(:); 
                                
[hs,wz]=sort(s,1,'descend');
hs(find(hs==0))=[]; 
for i=1:size(hs)
    [sub(i,1),sub(i,2)]=ind2sub(size(p),wz(i));   %将P矩阵各元素索引转换成坐标，并存储到sub矩阵
end
svt=[hs,sub];
route=zeros(m-1,m-1);
sv=0;
for j=1:m-1
 for i=1:size(svt)          %求从最大节约值开始，可一起配送的两个客户，作为初始解
  if A(3,(svt(i,2)+1))+A(3,(svt(i,3)+1))<=rong             
     solut=[svt(i,2),svt(i,3)];
     sv=sv+svt(i,1);
     zhuang=A(3,(solut(1,1)+1))+A(3,(solut(1,2)+1));
     ii=i;
     break
  end
 end

 for i=(ii+1):size(svt) 
    
      if     (svt(i,2)==solut(1,1))&&(isempty(find(svt(i,3)==solut))==1)&&((A(3,(svt(i,3)+1))+zhuang)<=rong);   %从最大的小于初始解对应的最大节约值对应的坐标判断（左坐标等于最优解的左坐标，并且右坐标不等于最优解的右坐标，并且容量不超）
              solut=[svt(i,3),solut];  %如满足条件，将右坐标加到路径的左侧
              sv=sv+svt(i,1);
              zhuang=A(3,(svt(i,3)+1))+zhuang;
      elseif (svt(i,2)==solut(1,length(solut)))&&(isempty(find(svt(i,3)==solut))==1)&&((A(3,(svt(i,3)+1))+zhuang)<=rong);
              solut=[solut,svt(i,3)];
              sv=sv+svt(i,1);
              zhuang=A(3,(svt(i,3)+1))+zhuang;
      elseif (svt(i,3)==solut(1,1))&&(isempty(find(svt(i,2)==solut))==1)&&((A(3,(svt(i,2)+1))+zhuang)<=rong);
              solut=[svt(i,2),solut];
              sv=sv+svt(i,1);
              zhuang=A(3,(svt(i,2)+1))+zhuang;
      elseif  (svt(i,3)==solut(1,length(solut)))&&(isempty(find(svt(i,2)==solut))==1)&&((A(3,(svt(i,2)+1))+zhuang)<=rong);
              solut=[solut,svt(i,2)];
              sv=sv+svt(i,1);
              zhuang=A(3,(svt(i,2)+1))+zhuang;
      else continue
      end
 end

 for i=size(svt):-1:1   %删除已经选到路径中的点
    if ((isempty(find(svt(i,2)==solut))==0)||(isempty(find(svt(i,3)==solut))==0))
    svt(i,:)=[];
    else continue
    end
 end

route(j,(1:length(solut)))=solut;  %将确定好的某一条路径存到route矩阵的一行中

if isempty(svt)  %直到判断svt无元素，退出
 break
 end
end
route(any(route,2)==0,:)=[];