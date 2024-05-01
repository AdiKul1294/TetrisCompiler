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
def showNext():
    global show_next
    show_next = True

def incSpeed():
    i = 1
    while i < 10 :
        global speed_increase_factor
        speed_increase_factor = speed_increase_factor + 0.1
        i = i + 1

def mainFunc():
    showNext()
    incSpeed()


#ENGINE:
if __name__ == '__main__':
	mainFunc()
	tetris_engine = TetrisEngine(fg = fg_color, bg = bg_color, show_next = show_next, dist = 1, extetromino_distribution = extetromino_distribution, show_grid = show_grid, speed_up = speed_increase_factor)


