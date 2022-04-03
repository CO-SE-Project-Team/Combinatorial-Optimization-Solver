import numpy as np
import matplotlib.pyplot as plt
from gurobipy import Model, GRB, quicksum
rnd = np.random
rnd.seed(0)
n = 100 # 1 depot and 20 clients
Capacity = 20
xc = rnd.rand(n+1)*200 # [0, ..., n-1]
yc = rnd.rand(n+1)*200
plt.plot(xc[0], yc[0], c='r', marker='s')
plt.scatter(xc[1:], yc[1:], c='b')
N = [i for i in range(0, n)] # set points
C = N[1:] # set of clients
A = [(i, j) for i in N for j in N if i != j] # set of all arcs
dis = {(i,j): np.hypot(xc[i]-xc[j], yc[i]-yc[j]) for (i, j) in A} # dictionary for dis
Dmd = {i: rnd.randint(1, 10) for i in C} # dictionary for clients demands
mdl = Model('CVRP') # set model
x = mdl.addVars(A, vtype=GRB.BINARY) # dictionary
f = mdl.addVars(A, vtype=GRB.CONTINUOUS) # dictionary
mdl.modelSense = GRB.MINIMIZE
mdl.setObjective(quicksum(x[(i, j)]*dis[(i, j)] for (i, j) in A))
mdl.addConstrs(quicksum(x[(i, j)] for j in N if j != i) == 1 for i in C) # from i, only 1
mdl.addConstrs(quicksum(x[(j, i)] for j in N if i != j) == 1 for i in C) # come to i, only 1
mdl.addConstrs(quicksum(f[(j, i)] for j in N if j != i) - quicksum(f[(i, j)] for j in N if j != i) == Dmd[i] for i in C)
mdl.addConstrs(0 <= f[(i, j)] for (i,j) in A)
mdl.addConstrs(f[(i, j)] <= Capacity*x[(i, j)] for (i,j) in A)
mdl.Params.MIPGap = 0.1
mdl.Params.TimeLimit = 20  # seconds
mdl.optimize()
active_arcs = [a for a in A if x[a].x > 0.99]
for i, j in active_arcs:
    plt.plot([xc[i], xc[j]], [yc[i], yc[j]], c='g', zorder=0)

plt.plot(xc[0], yc[0], c='r', marker='s')
plt.scatter(xc[1:], yc[1:], c='b')
plt.show()