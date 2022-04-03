import numpy as np
from matplotlib import pyplot as plt


class Mypy:

    def __init__(self, a, b):
        self.a = a
        self.b = b

        x = np.arange(1, 11)
        y = 2 * x + 5
        plt.title("Matplotlib demo")
        plt.xlabel("x axis caption")
        plt.ylabel("y axis caption")
        plt.plot(x, y)
        plt.show()
        print("hello world")
    def setA(self, a):
        self.a = a
        print("setted")

    def sumofAandB(self):
        return self.a + self.b