function Data = Greedy(Data)
%贪心算法
inputIndex = [Data.cx.' , Data.cy.'];
timelimit = 1;
t1 = clock;
n = size(inputIndex, 1);
inputAdjacencyMatrix = zeros(n);
for i = 1:n
    for j = 1:n
        inputAdjacencyMatrix(i, j) = sqrt((inputIndex(i, 1) - inputIndex(j, 1)) ^ 2 + (inputIndex(i, 2) - inputIndex(j, 2)) ^ 2);
    end
end
row = size(inputAdjacencyMatrix, 1);
outputRoad = [];%输出路径
outputCost = 0;%输出总长度
havePass = zeros(1, row);%标记点是否被走过
nextPoint = 1;%确定开始点
haveNumber = 0;%确定已走路程
while haveNumber < row
    havePass(1, nextPoint) = 1;
    outputRoad = [outputRoad, nextPoint];
    min = 0;
    haveNumber = haveNumber + 1;
    for i = 1:row%确定起始搜索点
        if havePass(1, i) == 0
            min = inputAdjacencyMatrix(nextPoint, i);
            break
        end
    end
   tem = nextPoint;
    for i = 1:row%找到最短的路径
        if havePass(1, i) == 0 && inputAdjacencyMatrix(tem, i) <= min
            min = inputAdjacencyMatrix(tem, i);
            nextPoint = i;
        end
    end
    outputCost = outputCost + min;
end
objVal = 0;
t2 = clock;
t = etime(t2, t1);  
if t > timelimit
    objVal = -1;
end
outputRoad = [outputRoad , 1];
outputCost = outputCost + inputAdjacencyMatrix(row, 1);

Data.problem = 'TSP';
Data.xi = outputRoad(1, 1:n);
Data.xj = outputRoad(1 , 2:n + 1);
Data.n = n;
Data.cx = inputIndex(:, 1).';
Data.cy = inputIndex(:, 2).';
Data.dis = inputAdjacencyMatrix;
Data.objVal = outputCost;
Data.timelimit = timelimit;
end