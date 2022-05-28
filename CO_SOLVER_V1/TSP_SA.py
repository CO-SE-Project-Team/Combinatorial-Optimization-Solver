import random
import copy
import math

class SASolution():
	"""
	模拟退火算法解决TSP问题:
	SA（Simulated annealing)
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

	def sa(self):
		"""
		模拟退火算法，查找全局最优解
		查找过程参考：
		交换任意两个节点的顺序, 找到局部最优解
		退火的方式：
		 1.降温系数α<1，以Tn+1=αTn的形式下降，比如取α=0.99 (*目前采用)
		 2.Tn=T0/(1+n)
		 3.Tn=T0/log(1+n)
		"""
		router = self.points
		distance = self.router_distance(router)
		sol=[0 for x in range(1, self.n+1)]
		a = 0.99  # 降温系数
		turn = self.iterations
		e = math.e
		for _ in range(turn):
			p1 = int(random.random() * self.length)
			p2 = int(random.random() * self.length)
			while p1 == p2:
				p2 = int(random.random() * self.length)

			temp = copy.deepcopy(router)
			temp[p1], temp[p2] = temp[p2], temp[p1]
			curr_distance = self.router_distance(temp)
			if curr_distance < distance * e ** a:
				distance = curr_distance
				router = temp
				for i in range(self.n):
					for j in range(self.n):
						if router[i]==self.points[j]:
							sol[i]=j+1
			# 更新降温系数
			a = a * a
		sol.append(sol[0])
		return distance,sol

	def get_solved_Data(self, Data):
		self.Data = Data
		self.problem = self.Data['problem']
		self.n = self.Data['n']
		self.Capacity = self.Data['capacity']
		self.Dmd = self.Data['demand']
		self.xc = self.Data['cx']
		self.yc = self.Data['cy']
		self.TimeLimit = self.Data['timeLim']
		self.iterations=self.Data['iterations']

		self.points = list(zip(self.xc,self.yc))
		self.length = len(self.points)
		self.map = self.distance_map()

		distance,sol=self.sa()

		self.objVal = distance
		self.Data['xi'] = sol[0:self.n]
		self.Data['xj'] = sol[1:self.n+1]
		self.Data['objVal'] = distance

		return self.Data

