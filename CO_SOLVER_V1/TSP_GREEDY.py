import random
import copy
import math

class GreedSolution():
	"""
	TSP（Travelling Salesman Problem）
	旅行商问题的类
	"""
	def __init__(self):
		"""
		points包含了所有旅行城市的位置坐标，起点默认是（0，0）
		points例如: [(1,2), (3,2)]
		"""
		# 加入起点
		self.problem = 'TSP'
		self.n = 20
		self.Capacity = 20
		self.Dmd = []
		self.xc = [1]
		self.yc = [2]
		self.points = list(zip(self.xc,self.yc))
		self.TimeLimit = 20
		self.iterations = 1
		self.length = len(self.points)
		self.map = self.distance_map()
		self.Data = {}

	def distance(self, point1, point2):
		"""
		计算两点之间的距离
		point1: (x1, y1)
		point2: (x2, y2)
		"""
		return ((point1[0] - point2[0]) ** 2 + 
				(point1[1] - point2[1]) ** 2) ** 0.5

	def distance_map(self):
		"""
		计算所有点到点之间的距离数组
		例如
		    起点 点1 点2
		[
		起点[0,  2,  3],
		点1 [1,  0,  2],
		点2 [3,  2,  0]
		]
		"""
		map = [[0 for _ in range(self.length)] 
				   for _ in range(self.length)]
		for row in range(self.length):
			for col in range(self.length):
				map[row][col] = self.distance(self.points[row], self.points[col])
		return map

	def router_distance(self, router):
		"""
		计算路径的总距离
		router: [(0, 0), (x1, x2), (x2, y2), (x3, y3)]
		最后还要回到(0, 0)
		"""
		router = router + [(0, 0)]
		ret = 0
		for i in range(1, len(router)):
			ret += self.distance(router[i-1], router[i])
		return ret

	def nearest(self, row, arrived):
		"""
		找到贪心算法在某个点上可以选择的最优的点的坐标
		row: 某个点对应与另外所有点的距离列表
		arrvied: 已经到达过的点的集合
		"""
		min_ = float('inf')
		index = None
		# print("arrived in nearest:", arrived)
		for i in range(len(row)):
			if i in arrived or row[i] == 0:
				continue
			if row[i] < min_:
				min_ = row[i]
				index = i
		return index

	def greed(self):
		"""
		从起点(0, 0)出发，选择最近的点；
		再从该点出发，选择最近的点；
		重复执行该步骤，直到没有点时返回起点。

		返回路径
		例如： [(0, 0), (3, 4), (0, 0)]
		"""
		curr = 0
		router = [self.points[0]]
		sol=[0 for x in range(1, self.n+1)]
		arrived = set()
		arrived.add(0)
		total_distance = 0
		while True:
			curr = self.nearest(self.map[curr], arrived)
			if curr is None:
				break
			router.append(self.points[curr])
			arrived.add(curr)
		for i in range(self.n):
			for j in range(self.n):
				if router[i]==self.points[j]:
					sol[i]=j+1
		# print(arrived, router)
		# print("greed 总距离:", self.router_distance(router))
		sol.append(sol[0])
		return self.router_distance(router),sol

	def get_solved_Data(self, Data):
		self.Data = Data
		self.problem = self.Data['problem']
		self.n = self.Data['n']
		self.Capacity = self.Data['capacity']
		self.Dmd = self.Data['demand']
		self.xc = self.Data['cx']
		self.yc = self.Data['cy']
		self.TimeLimit = self.Data['timeLim']

		self.points = list(zip(self.xc,self.yc))
		self.length = len(self.points)
		self.map = self.distance_map()

		distance,sol=self.greed()

		self.objVal = distance
		self.Data['xi'] = sol[0:self.n]
		self.Data['xj'] = sol[1:self.n+1]
		self.Data['objVal'] = distance

		return self.Data
