# 物品重量与价值
tr = [None, {'w': 2, 'v': 6}, {'w': 2, 'v': 3},
      {'w': 6, 'v': 5}, {'w': 5, 'v': 4}, {'w': 4, 'v': 6}]
# 最大容量
max_w = 10
# 初始化二维表格
# 集合的形式作为二维表格
m = {(i, w): 0 for i in range(len(tr))
     for w in range(max_w + 1)}
for i in range(1, len(tr)):
    for w in range(1, max_w + 1):
        if tr[i]['w'] > w:
            m[(i, w)] = m[(i - 1, w)]
        else:
            m[(i, w)] = max(m[(i - 1, w)], m[(i - 1, w - tr[i]['w'])] + tr[i]['v'])
print(type(m))
print(m[(len(tr) - 1, max_w)])
