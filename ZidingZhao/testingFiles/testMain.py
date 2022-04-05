import ClassMypy

mc = ClassMypy.Mypy(1, 2)
mc.makeC(888)
print(mc.c)
mc.c = 456
print(mc.c)
print(mc.getC())