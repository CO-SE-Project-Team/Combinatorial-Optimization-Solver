VRP_Data = load('VRP_Data.mat').VRP_Data;

% clear classes
% obj = py.importlib.import_module('VRP_Python_Class_Gurobi');
% py.importlib.reload(obj);

VRPGurobi = py.VRP_Python_Class_Gurobi.VRPGurobi();
VRPGurobi.set_all(VRP_Data.n, VRP_Data.Capacity, VRP_Data.Dmd, VRP_Data.xc, VRP_Data.yc, VRP_Data.TimeLimit);
VRPGurobi.optimize();
xc = double(VRPGurobi.get_xc());
yc = double(VRPGurobi.get_yc());
active_A = cell(VRPGurobi.get_active_A());
active_ci = int64(double(VRPGurobi.get_active_ci()));
active_cj = int64(double(VRPGurobi.get_active_cj()));
objVal = VRPGurobi.get_objVal();

G = graph(active_ci+1,active_cj+1);
plot(G,'XData',xc,'YData',yc)
hold on;
scatter(xc(1),yc(1),50,'red','filled','s');
hold on;
scatter(xc(2:end),yc(2:end),20,'blue','filled');

% diary("Status_Output(MatlabSoloverPython)");
% diary on;
% 
% diary off;
% output=fileread('example');
% 
% set(handles.editbox1,'string',output);
% delete('example');