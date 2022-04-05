VRP_Data.n = int8(20);
VRP_Data.Capacity = int8(20);

VRP_Data.Dmd = int64(randi(10,1,VRP_Data.n));
VRP_Data.Dmd(1) = 0; % this line can be ignored due to the math model
% for i = 1:length(VRP_Data.Dmd)
%     VRP_Data.Dmd(i) = int64(VRP_Data.Dmd(i));
% end

VRP_Data.xc = int64(randi(20,1,VRP_Data.n));
% for i = 1:length(VRP_Data.xc)
%     VRP_Data.xc(i) = int64(VRP_Data.xc(i));
% end

VRP_Data.yc = int64(randi(20,1,VRP_Data.n));
% for i = 1:length(VRP_Data.yc)
%     VRP_Data.yc(i) = int64(VRP_Data.yc(i));
% end

VRP_Data.TimeLimit = int8(20);
save VRP_Data