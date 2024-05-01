from engine import *

#PRIMITIVE:
fg_color = "green"
bg_color = "black"
speed_increase_factor = 1
show_grid = False
show_next = False
extetromino_distribution = [3, 2, 2, 1, 1, 1, 2, 2, 3]
height = 0
width = 0

#FUNCTIONS:
def setGrid():
    global show_grid
    show_grid = True

def setHeight(ht):
    global height
    height = ht

def setWidth(wid):
    global width
    width = wid

def setFg(color):
    global fg_color
    fg_color = color

def mainFunc():
    setGrid()
    setFg(color = "red")
    setHeight(ht = 10)
    setWidth(wid = 20)


#ENGINE:
if __name__ == '__main__':
	mainFunc()
	tetris_engine = TetrisEngine(height = height, width = width, fg = fg_color, bg = bg_color, show_next = show_next, dist = 1, extetromino_distribution = extetromino_distribution, show_grid = show_grid)


