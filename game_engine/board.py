#    board.py: creates and manipulates a block board for tetris-like games
#    Copyright (C) 2024  Ramprasad S. Joshi
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

import numpy
class Board(object):
    def __init__(self, width=10, height=20, next = numpy.array([]), show_next=True, show_grid=True):
        self.width = width
        self.height = height
        self.area = numpy.full_like([[False]], False, shape=(self.height, self.width))
        self.next_piece = numpy.array([[True, True, True, True]])
        self.show_next = show_next
        self.show_grid = show_grid

    def __str__(self):
        tempArea = ""
        for row in range(self.height):
            for col in range(self.width):
                if self.show_grid:
                    if col == 0:
                        tempArea += '|'
                    if self.area[row][col]:
                        tempArea += '\N{BLACK LARGE SQUARE}|'  # was '\u25A1|'
                    else:
                        tempArea += '_|'
                else:
                    if col == 0:
                        tempArea += '|'
                    if self.area[row][col]:
                        tempArea += '\N{BLACK LARGE SQUARE} '  # was '\u25A1|'
                    elif row == self.height - 1:
                        tempArea += '_ '
                    else:
                        tempArea += '  '
                    if col == self.width - 1:
                        tempArea += '|'
            tempArea += "\n"

        if self.next_piece.shape[0] > 0 and self.show_next:
            tempArea += "\nNext piece:\n"
            for row in range(self.next_piece.shape[0]):
                for col in range(self.next_piece.shape[1]):
                    if self.next_piece[row][col]:
                        tempArea += '\N{BLACK LARGE SQUARE} '  # was '\u25A1|'
                    else:
                        tempArea += '  '
                tempArea += "\n"

        return tempArea
    
    def updateNext(self, piece):
        self.next_piece = piece

    def insertShape(self, shape, rowIndex=0, columnIndex=0):
        for row in range(shape.shape[0]):
            for column in range(shape.shape[1]):
                if shape[row][column]:
                    self.area[rowIndex + row][columnIndex + column] = True

    def removeShape(self, shape, rowIndex=0, columnIndex=0):
        for row in range(shape.shape[0]):
            for column in range(shape.shape[1]):
                if shape[row][column]:
                    self.area[rowIndex + row][columnIndex + column] = False

    def collision(self, shape, offset):
        off_y, off_x = offset
        for cy, row in enumerate(shape):
            for cx, cell in enumerate(row):
                try:
                    if cell and self.area[cy + off_y][cx + off_x]:
                        return True
                except IndexError:
                    return True
        return False

if __name__ == "__main__": # for testing. Requires some tetrominoes in allextetrominoes.py
	from allextetrominoes import *
	from shape import Shape
	from time import time, sleep
	this = Board(10,10)
	this.insertShape(get_any_extetromino(),5,5) # from allextetrominoes
	i = int(input("Give i "))
	j = int(input("Give j "))
	print(this)
	while(i+j):
		shape = get_any_extetromino()
		print(shape)
		if this.collision(shape,(i,j)):
			print("Collision")
			this.area[i][j] = True
			print(this)
			this.area[i][j] = False
		else:
			print("No collision")
			this.insertShape(shape,i,j)
			print(this)
			this.removeShape(shape,i,j)
		i = int(input("Give i "))
		j = int(input("Give j "))
#	for i in range(1,74):	# For testing all the extetrominoes
#		this=Board(10,10)
#		import allextetrominoes
#		shape=Shape(eval("Extetromino"+str(i)))
#		this.insertShape(shape.matrix,5,5)
#		print(this)
#		sleep(1)
#		this.removeShape(shape.matrix,5,5)
#		shape.rotateCW()
#		this.insertShape(shape.matrix,5,5)
#		print(this)
#		sleep(1)
#		this.removeShape(shape.matrix,5,5)
#		shape.rotateAntiCW()
#		this.insertShape(shape.matrix,5,5)
#		print(this)
#		sleep(1)
#		this.removeShape(shape.matrix,5,5)
