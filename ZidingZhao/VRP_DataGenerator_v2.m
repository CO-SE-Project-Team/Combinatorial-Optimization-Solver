
VRP_Data.n = int64(20);
VRP_Data.capacity = int64(20);

VRP_Data.demand = int64(randi(10,1,VRP_Data.n));
VRP_Data.demand(1) = 0; % this line can be ignored due to the math model
% for i = 1:length(VRP_Data.Dmd)
%     VRP_Data.Dmd(i) = int64(VRP_Data.Dmd(i));
% end

VRP_Data.cx = int64(randi(20,1,VRP_Data.n));
% for i = 1:length(VRP_Data.xc)
%     VRP_Data.xc(i) = int64(VRP_Data.xc(i));
% end

VRP_Data.cy = int64(randi(20,1,VRP_Data.n));
% for i = 1:length(VRP_Data.yc)
%     VRP_Data.yc(i) = int64(VRP_Data.yc(i));
% end

VRP_Data.timeLim = int64(10);
save VRP_Data_v2