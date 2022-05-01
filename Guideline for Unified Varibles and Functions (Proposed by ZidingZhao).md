# Guideline for Unified Variables and Functions v5.7

NOTE: Critical variables and functions are marked with **※** in the front.

## Unified Variables
* **※** **Data** *(struct)*: includes all the variables Below.
* **problem** *(string)*: "TSP", "VRP", "KP"/"Knapsack".
*  **n** *(int)*: Total number of nodes, including Starting Point/Depot.
*  **capacity/c/cap/cpct** *(int/double)*: Indicates the capacity of Truck/Knapsack
*  **demand/dmd/d/weight** *(1×n array/matrix)*: Demand for every customer(VRP Only). weight of items(KP)
* **cx/cX/coord_x** *(1×n array/matrix)*: Coordinate x for Start/Depot(TSP/VRP) and cities/clients(TSP/VRP). First one being Start/Depot(TSP/VRP). Index for each item(Knapsack).
* **cy/cY/coord_y** *(1×n array/matrix)*: Coordinate y for Start/Depot(TSP/VRP) and cities/clients(TSP/VRP). First one being Start/Depot(TSP/VRP). Value for each item(Knapsack).
* **distance/dis** *(n×n array/matrix)*: Distance between each two nodes(TSP/VRP), from node i to node j.
* **xi** *(1×size(xi) array/matrix)*: starting node i if xij == 1. xi == i(Knapsack Problem). NOTE: size(xi) = size(xj)
* **xj** *(1×size(xj) array/matrix)*: end node j if xij == j. Null for Knapsack Problem. NOTE: size(xi) = size(xj)
* **objVal** *(double)*: the min/max value of the object function.
* **iterations** *(int)*: shows how many iterations the algorithm takes.
* **iterator** *(int)*: shows current times of iterations.
* (debatable) **timeLim/timeLimit/time_limit** *(int)*: Runtime limit in seconds.
* More possible parameters for different algorithms.
* algorithm *(string)*: "BF", "MC", "GREEDY", "DP", "GA", "SA", "KNN", "TWOOPT", "VNS", "ACO".

## Unified Functions/Methods
* **※** **set_Data(Data)**: set all using struct Problem.
* **※** **solve()**: Solve the problem according to the Data struct, return the Data which is updated by the algorithm.
* **※** **get_Data()** *(struct)*: NOTE: Recommended for algorithms output.
* **※** **pause()**: pause the algorithm.
* **※** **resume()**: resume the algorithm.
* **※** **get_solved_Data(Data)** *(struct)*: set & get Data, all in one.
* **※** **start_clock()**: start the timing clock.
* **※****is_stop()** *(boolean)*: return a boolean flag for whether the algorithm should stop the iteration.
* **set_all(problem, n, capacity, cx, cy, timeLimit)**: set all possible variables, some variables could be ignored.
* **set_n(n)** 
* **set_capacity(capacity)** 
* **set_demand(demand)/set_weight(weight)**: demand of each customer(VRP), or weight for each item(KP)
* **set_cx(cx)** 
* **set_cy(cy)** 
* (debatable) **set_timeLim(timeLim)** 
* **solve()**: Solve the problem.
* **get_result()/get_all()** *(struct)*: NOTE: NOT recommended!
* **get_problem()**
* **get_n()** *(int)*
* **get_capacity()** *(int/double)*
* **get_cx()** *(1×n array/matrix)*
* **get_cy()** *(1×n array/matrix)*
* **get_timeLim(timeLim)** *(int)*
* **get_xi()** *(int)*
* **get_xj()** *(int)*
* **get_objVal()** *(double)*
* More possible functions/methods for different algorithms.