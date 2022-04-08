# Guideline for Unified Variables and Functions v1.0

## Unified Variables
* **Problem** *(struct)*: includes all the variables.
* **problem** *(string)*: "TSP", "VRP", "Knapsack"/"KP".
*  **n** *(int)*: Total number of nodes, including Starting Point/Depot.
*  **capacity/c/cap/cpct** *(int/double)*: Indicates the capacity of Truck/Knapsack
*  **demand/dmd/d** *(1×n array/matrix)*: Demand for every customer(VRP Only).
* **cx/cX/coord_x** *(1×n array/matrix)*: Coordinate x for Start/Depot(TSP/VRP) and cities/clients(TSP/VRP). First one being Start/Depot(TSP/VRP). Index for each item(Knapsack).
* **cy/cY/coord_y** *(1×n array/matrix)*: Coordinate y for Start/Depot(TSP/VRP) and cities/clients(TSP/VRP). First one being Start/Depot(TSP/VRP). Value for each item(Knapsack).
* **distance/dis** *(n×n array/matrix)*: Distance between each two nodes(TSP/VRP), from node i to node j.
* **xi** *(int)*: starting node i if xij == 1. xi == 1(Knapsack Problem).
* **xj** *(int)*: end node j if xij == 1. Null for Knapsack Problem.
* **objVal** *(double)*: the min/max value of the object function.
* (debatable) **timeLim/timeLimit/time_limit** *(int)*: Runtime limit in seconds.
* More possible parameters for different algorithms.

## Unified Functions/Methods
* **set_Problem(Problem)**: set all using struct Problem.
* **set_all(problem, n, capacity, cx, cy, timeLimit)**: set all possible variables, some variables could be ignored.
* **set_problem(problem)**
* **set_n(n)** 
* **set_capacity(capacity)** 
* **set_cx(cx)** 
* **set_cy(cy)** 
* (debatable) **set_timeLim(timeLim)** 
* **optimize()**: Optimize the problem.
* **optimize(Problem)**: Optimize the problem according to the Problem struct.
* **get_result()/get_all()** *(struct)*
* **get_problem()**
* **get_n()** *(int)*
* **get_capacity()** *(int/double)*
* **get_cx()** *(1×n array/matrix)*
* **get_cy()** *(1×n array/matrix)*
* **get_timeLim(timeLim)** *(int)*
* **get_xi()** *(int)*
* **get_xj()** *(int)*
* **get_objVal()** *(double)*
* (debatable) **stop()**: stop the algorithm.
* More possible functions/methods for different algorithms.