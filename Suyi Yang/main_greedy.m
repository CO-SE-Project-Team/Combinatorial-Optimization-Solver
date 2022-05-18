clear;clc;

demand = [0 10 2 10 10];
cx=[10 17 3 9 19];
cy=[16 20 14 1 17];
D = demand;                                % Demands
n=length(D);                           % Total of points
points=[];
for i=1:n
    points(i,1)=cx(i);
    points(i,2)=cy(i);
end

PR = points;                               % Coordinates

capacity = 20;                                   % Vehicle max capacity
DT = sum(D);                               % Total demand
CantV=round(DT/capacity)+round(n*0.05);      % Vehicle quantity approximate
[n,~]=size(PR);
MDist=zeros(n,n);
totalD=0;
for i=1:n
    p1=PR(i,:);
    for j=i+1:n
        p2=PR(j,:);
        d=sqrt(((p2(1)-p1(1))^2)+((p2(2)-p1(2))^2));
        MDist(i,j)=d;
        totalD=totalD+d;
        MDist(j,i)=d;
    end
end

unvisited = 2:n;                       % Points not visited. All in the first time except depot
vehicles = zeros(CantV,n);
demands = [];
distances = [];
iter = 1;
r=[1];
temp_demad = D(unvisited);
    point_demand = [unvisited;temp_demad];
    point_demand = sortrows(point_demand',2);
for j=1:n-1
            r=[r,point_demand(j,1)];
        end
while ~isempty(unvisited)  
    temp_demad = D(unvisited);
    point_demand = [unvisited;temp_demad];
    point_demand = sortrows(point_demand',2);
    [cantP,~]=size(point_demand);
    vehicle = [];
    demand = 0;
    distance = 0;
    i = 1;
    last = 0;
    while(i <= cantP && demand + point_demand(i,2)<= capacity)
        if i == 1
            distance = distance + MDist(1,point_demand(i,1));
        else
            distance = distance + MDist(vehicle(last),point_demand(i,1));
        end
        vehicle = [vehicle, point_demand(i,1)];
        last = last + 1;
        demand = demand + point_demand(i,2);
        unvisited = unvisited(unvisited ~= point_demand(i,1));        
        i=i+1;
    end
    vehicles(iter,1:length(vehicle))= vehicle;
    iter = iter+1;
    demands = [demands,demand];
    distances = [distances,distance];
    
end
cantRealVehicles = iter -1;
objVal = sum(distances)
r=[r,1]
xi=r(1:n);
xj=r(2:n+1);

% % Save to a file the results
% save(strcat('results/greedy_results'));
