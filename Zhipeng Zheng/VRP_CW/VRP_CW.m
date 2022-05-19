classdef VRP_CW < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
    % SubALGORITHM 继承了 ALGORITHM
    % 父类具有 Data 结构体, 此处无需再次声明、
    % 本类不需要有任何变量
    methods
        % 本类有且仅有以下一种方法/函数
        function solve(obj)
            % 把父类Data中变量赋予该类中你需要使用的变量， 不同问题可能不同
            % 如;
            problem = obj.Data.problem;
            n = obj.Data.n;
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;
            xi = obj.Data.xi;
            xj = obj.Data.xj;
            objVal = obj.Data.objVal;

            
            C=[cx;cy];% 存放城市之间距离的矩阵
            rong=capacity;
            m=n;
            c=zeros(m,m);
            for j=1:m
                for i=(j+1):m
                    qq = double((C(1,i)-C(1,j))^2+(C(2,i)-C(2,j))^2);
                    c(i,j)=sqrt(qq);
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
                    if demand(1,(svt(i,2)+1))+demand(1,(svt(i,3)+1))<=rong
                        solut=[svt(i,2),svt(i,3)];
                        sv=sv+svt(i,1);
                        zhuang=demand(1,(solut(1,1)+1))+demand(1,(solut(1,2)+1));
                        ii=i;
                        break
                    end
                end

                for i=(ii+1):size(svt)

                    if     (svt(i,2)==solut(1,1))&&(isempty(find(svt(i,3)==solut))==1)&&((demand(1,(svt(i,3)+1))+zhuang)<=rong)  %从最大的小于初始解对应的最大节约值对应的坐标判断（左坐标等于最优解的左坐标，并且右坐标不等于最优解的右坐标，并且容量不超）
                        solut=[svt(i,3),solut];  %如满足条件，将右坐标加到路径的左侧
                        sv=sv+svt(i,1);
                        zhuang=demand(1,(svt(i,3)+1))+zhuang;
                    elseif (svt(i,2)==solut(1,length(solut)))&&(isempty(find(svt(i,3)==solut))==1)&&((demand(1,(svt(i,3)+1))+zhuang)<=rong)
                        solut=[solut,svt(i,3)];
                        sv=sv+svt(i,1);
                        zhuang=demand(1,(svt(i,3)+1))+zhuang;
                    elseif (svt(i,3)==solut(1,1))&&(isempty(find(svt(i,2)==solut))==1)&&((demand(1,(svt(i,2)+1))+zhuang)<=rong)
                        solut=[svt(i,2),solut];
                        sv=sv+svt(i,1);
                        zhuang=demand(1,(svt(i,2)+1))+zhuang;
                    elseif  (svt(i,3)==solut(1,length(solut)))&&(isempty(find(svt(i,2)==solut))==1)&&((demand(1,(svt(i,2)+1))+zhuang)<=rong)
                        solut=[solut,svt(i,2)];
                        sv=sv+svt(i,1);
                        zhuang=demand(1,(svt(i,2)+1))+zhuang;
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

            for i =1:n

            end
            
            route(any(route,2)==0,:)=[];
            route = route + 1;
            final = [1];
            for i = 1:size(route, 1)
                for j = 1:size(route, 2)
                    final = [final,route(i,j)];
                    if route(i, j) == 1
                        break;
                    end
                end
            end
            for i = 2:size(final, 2)
                a = 0;
                b = 0;
                if final(1, i) > final(1, i - 1)
                    a = final(1, i);
                    b = final(1, i - 1);
                else
                    b = final(1, i);
                    a = final(1, i - 1);
                end
                objVal = objVal + c(a, b); 
            end
            xi = final(1, 1:size(final, 2) - 1);
            xj = final(1, 2:size(final,2));
            obj.Data.xi=xi;
            obj.Data.xj=xj;
            obj.Data.objVal=objVal;
            obj.Data.distance = C;
            %obj.update_status_by(objVal, xi, xj); % 这将会把当前的objVal，xi，xj更新到GUI中。
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