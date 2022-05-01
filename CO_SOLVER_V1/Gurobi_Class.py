import numpy as np
import matplotlib.pyplot as plt
from gurobipy import Model, GRB, quicksum

class Gurobi:
    def __init__(self):
        self.problem = 'VRP'
        self.n = 20
        self.Capacity = 20
        self.Dmd = []
        self.xc = []
        self.yc = []
        self.TimeLimit = 20

        self.Data = {}
        
    def set_all(self, n, Capacity, Dmd, xc, yc, TimeLimit):
        self.n = n
        self.Capacity = Capacity
        self.Dmd = Dmd
        self.xc = xc
        self.yc = yc
        self.TimeLimit = TimeLimit

    def optimize(self):
        self.N = [i for i in range(0, self.n)] # set points
        self.status = 'ok'
        self.C = self.N[1:] # set of clients
        self.A = [(i, j) for i in self.N for j in self.N if i != j] # set of all arcs
        self.dis = {(i,j): np.hypot(self.xc[i]-self.xc[j], self.yc[i]-self.yc[j]) for (i, j) in self.A} # dictionary for dis
        self.Dmd = {i: self.Dmd[i] for i in self.C} # dictionary for clients demands
        self.mdl = Model('CVRP') # set model
        self.x = self.mdl.addVars(self.A, vtype=GRB.BINARY) # dictionary
        self.f = self.mdl.addVars(self.A, vtype=GRB.CONTINUOUS) # dictionary
        self.mdl.modelSense = GRB.MINIMIZE
        self.mdl.setObjective(quicksum(self.x[(i, j)]*self.dis[(i, j)] for (i, j) in self.A))
        self.mdl.addConstrs(quicksum(self.x[(i, j)] for j in self.N if j != i) == 1 for i in self.C) # from i, only 1
        self.mdl.addConstrs(quicksum(self.x[(j, i)] for j in self.N if i != j) == 1 for i in self.C) # come to i, only 1
        self.mdl.addConstrs(quicksum(self.f[(j, i)] for j in self.N if j != i) - quicksum(self.f[(i, j)] for j in self.N if j != i) == self.Dmd[i] for i in self.C)
        self.mdl.addConstrs(0 <= self.f[(i, j)] for (i,j) in self.A)
        self.mdl.addConstrs(self.f[(i, j)] <= self.Capacity*self.x[(i, j)] for (i,j) in self.A)
        self.mdl.Params.MIPGap = 0.1
        self.mdl.Params.TimeLimit = self.TimeLimit  # seconds
        self.mdl.optimize()
        self.active_A = [a for a in self.A if self.x[a].x > 0.99]
        self.active_ci = [a[0] for a in self.active_A]
        self.active_cj = [a[1] for a in self.active_A]
        self.objVal = self.mdl.objVal
        
    def get_xc(self):
        return self.xc

    def get_yc(self):
        return self.yc

    def get_active_A(self):
        return self.active_A

    def get_objVal(self):
        return self.objVal
    
    def get_active_ci(self):
        return self.active_ci

    def get_active_cj(self):
        return self.active_cj

    def solve(self): 
        self.problem = self.Data['problem']
        self.n = self.Data['n']
        self.Capacity = self.Data['capacity']
        self.Dmd = self.Data['demand']
        self.xc = self.Data['cx']
        self.yc = self.Data['cy']
        self.TimeLimit = self.Data['timeLim']

        self.N = [i for i in range(0, self.n)] # set points
        self.status = 'ok'
        self.C = self.N[1:] # set of clients
        self.A = [(i, j) for i in self.N for j in self.N if i != j] # set of all arcs
        self.dis = {(i,j): np.hypot(self.xc[i]-self.xc[j], self.yc[i]-self.yc[j]) for (i, j) in self.A} # dictionary for dis
        self.Dmd = {i: self.Dmd[i] for i in self.C} # dictionary for clients demands
        self.mdl = Model('CVRP') # set model
        self.x = self.mdl.addVars(self.A, vtype=GRB.BINARY) # dictionary
        self.f = self.mdl.addVars(self.A, vtype=GRB.CONTINUOUS) # dictionary
        self.mdl.modelSense = GRB.MINIMIZE
        self.mdl.setObjective(quicksum(self.x[(i, j)]*self.dis[(i, j)] for (i, j) in self.A))
        self.mdl.addConstrs(quicksum(self.x[(i, j)] for j in self.N if j != i) == 1 for i in self.C) # from i, only 1
        self.mdl.addConstrs(quicksum(self.x[(j, i)] for j in self.N if i != j) == 1 for i in self.C) # come to i, only 1
        self.mdl.addConstrs(quicksum(self.f[(j, i)] for j in self.N if j != i) - quicksum(self.f[(i, j)] for j in self.N if j != i) == self.Dmd[i] for i in self.C)
        self.mdl.addConstrs(0 <= self.f[(i, j)] for (i,j) in self.A)
        self.mdl.addConstrs(self.f[(i, j)] <= self.Capacity*self.x[(i, j)] for (i,j) in self.A)
        self.mdl.Params.MIPGap = 0.1
        self.mdl.Params.TimeLimit = self.TimeLimit  # seconds
        self.mdl.optimize()
        self.active_A = [a for a in self.A if self.x[a].x > 0.99]
        self.active_ci = [a[0] + 1 for a in self.active_A] # for matlab, index start from 1
        self.active_cj = [a[1] + 1 for a in self.active_A]
        self.objVal = self.mdl.objVal

        self.Data['xi'] = self.active_ci
        self.Data['xj'] = self.active_cj
        self.Data['objVal'] = self.objVal

    def get_solved_Data(self, Data):
        self.Data = Data
 
        self.problem = self.Data['problem']
        self.n = self.Data['n']
        self.Capacity = self.Data['capacity']
        self.Dmd = self.Data['demand']
        self.xc = self.Data['cx']
        self.yc = self.Data['cy']
        self.TimeLimit = self.Data['timeLim']

        self.N = [i for i in range(0, self.n)] # set points
        self.status = 'ok'
        self.C = self.N[1:] # set of clients
        self.A = [(i, j) for i in self.N for j in self.N if i != j] # set of all arcs
        self.dis = {(i,j): np.hypot(self.xc[i]-self.xc[j], self.yc[i]-self.yc[j]) for (i, j) in self.A} # dictionary for dis
        self.Dmd = {i: self.Dmd[i] for i in self.C} # dictionary for clients demands
        self.mdl = Model('CVRP') # set model
        self.x = self.mdl.addVars(self.A, vtype=GRB.BINARY) # dictionary
        self.f = self.mdl.addVars(self.A, vtype=GRB.CONTINUOUS) # dictionary
        self.mdl.modelSense = GRB.MINIMIZE
        self.mdl.setObjective(quicksum(self.x[(i, j)]*self.dis[(i, j)] for (i, j) in self.A))
        self.mdl.addConstrs(quicksum(self.x[(i, j)] for j in self.N if j != i) == 1 for i in self.C) # from i, only 1
        self.mdl.addConstrs(quicksum(self.x[(j, i)] for j in self.N if i != j) == 1 for i in self.C) # come to i, only 1
        self.mdl.addConstrs(quicksum(self.f[(j, i)] for j in self.N if j != i) - quicksum(self.f[(i, j)] for j in self.N if j != i) == self.Dmd[i] for i in self.C)
        self.mdl.addConstrs(0 <= self.f[(i, j)] for (i,j) in self.A)
        self.mdl.addConstrs(self.f[(i, j)] <= self.Capacity*self.x[(i, j)] for (i,j) in self.A)
        self.mdl.Params.MIPGap = 0.1
        self.mdl.Params.TimeLimit = self.TimeLimit  # seconds
        self.mdl.optimize()
        self.active_A = [a for a in self.A if self.x[a].x > 0.99]
        self.active_ci = [a[0] + 1 for a in self.active_A] # for matlab, index start from 1
        self.active_cj = [a[1] + 1 for a in self.active_A]
        self.objVal = self.mdl.objVal

        self.Data['xi'] = self.active_ci
        self.Data['xj'] = self.active_cj
        self.Data['objVal'] = self.objVal

        return self.Data

    def set_Data(self, Data):
        self.Data = Data

    def get_Data(self):
        return self.Data

    def pause(self):
        pass

    def resume(self):
        pass

# for (i, j) in active_arcs:
#     plt.plot([xc[i], xc[j]], [yc[i], yc[j]], c='g', e=0)   
# plt.plot(xc[0], yc[0], c='r', marker='s')
# plt.scatter(xc[1:], yc[1:], c='b')