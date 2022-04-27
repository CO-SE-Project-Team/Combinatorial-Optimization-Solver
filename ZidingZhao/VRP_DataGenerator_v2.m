Data.problem = 'VRP';
Data.n = int64(200);
Data.capacity = int64(20);

Data.demand = int64(randi(10,1,Data.n));
Data.demand(1) = 0; % this line can be ignored due to the math model
% for i = 1:length(Data.Dmd)
%     Data.Dmd(i) = int64(Data.Dmd(i));
% end

Data.cx = int64(randi(20,1,Data.n));
% for i = 1:length(Data.xc)
%     Data.xc(i) = int64(Data.xc(i));
% end

Data.cy = int64(randi(20,1,Data.n));
% for i = 1:length(Data.yc)
%     Data.yc(i) = int64(Data.yc(i));
% end

Data.iterations = int64(100);
Data.timeLim = int64(10);

Data.distance = [];
Data.xi = [];
Data.xj = [];
Data.objVal = int64(0);

save VRP_Data_Python_v2