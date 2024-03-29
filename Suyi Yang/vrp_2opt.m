clc;
close;

demand=[0,10,2,10,10];
capacity=20;
cx=[10,17,3,9,19];
cy=[16,20,14,1,17];
n=size(demand);

dis=zeros(n);
for i=2:n 
    for j=1:i
        dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);
    end
end
% for i = n+1:n+n-2
%     for j = 1:n
%         dis(i,j) = dis(1,j);
%     end
% end
dis = dis + dis';

% create all permutations
q = linspace(2,n+n-2,n+n-2-1);
q = perms(q);
p = zeros(size(q,1),size(q,2)+2);
for i = 1:size(q,1)
    p(i,:) = [1 q(i,:) 1];
end

% set all n:n+n-2 depot index to 1
for i = 1:size(p,1) % for every row
    for j = 1:size(p,2) % for every col
        if p(i,j) > n
            p(i,j) = 1;
        end
    end
end

% create minDis and route, find minimal legal route.
minDis = inf;
route = [];
for i = 1:size(p,1) % for every row in p
    d = 0;
    legal = true;
    for j = 1:size(p,2) % for every node in row
        if p(i,j) == 1 % skip 1
            d = 0;
            continue
        end

        d = d + demand(p(i,j)); % sum up all the nonezero node's demand
        if d > capacity
            legal = false;
            break;
        end
        
    end
    if legal == true % for legal route, update minDis & route.
        di = 0;
        for j = 1:size(p,2)-1
            di = di + dis(p(i,j),p(i,j+1));
        end
        if di < minDis
            minDis = di;
            route = p(i,:);
        end
    end
end
                