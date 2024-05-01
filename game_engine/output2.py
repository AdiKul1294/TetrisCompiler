from engine import *

#PRIMITIVE:
fg_color = "green"
bg_color = "white"
speed_increase_factor = 1
show_grid = False
show_next = False
extetromino_distribution = [1, 2, 3]

#FUNCTIONS:
def setDifficulty(diff, speed):
    if diff == 1 :
        global extetromino_distribution
        extetromino_distribution = [3, 2, 2, 1, 1, 1, 2, 2, 3]
        global speed_increase_factor
        speed_increase_factor = speed

def mainFunc():
    setDifficulty(diff = 2, speed = 1.2)


#ENGINE:
if __name__ == '__main__':
	mainFunc()
	tetris_engine = TetrisEngine(fg = fg_color, bg = bg_color, show_next = show_next, dist = 1, extetromino_distribution = extetromino_distribution, show_grid = show_grid, speed_up = speed_increase_factor)


