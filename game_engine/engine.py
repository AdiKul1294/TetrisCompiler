#    engine.py: A Programmable Tetris-like Games Engine
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

import tkinter as tk
from tkinter import filedialog
from board import Board
from allextetrominoes import *
from shape import Shape
from time import time, sleep
from copy import copy, deepcopy

class TetrisEngine:
	def __init__(self, show_next=True, show_grid=True, height=20, width=10, extetromino_distribution=range(1,20), speed_up=1,dist=0, fg="green", bg="black"):
		self.window = tk.Tk()											  # fixed
		self.window.title("Python Text Tetris")		  # Programmable, inconsequential
		self.extetromino_distribution = extetromino_distribution	# Programmable:
			# Controls the number, variety and distribution.
			# This can be changed to range(1,74) for the give allextetrominoes module. Or to your list too.
			# If you want some pieces to have more frequency than others, then repeat their index in this 
			# list, and in that case give a proper enumerated tuple or a list, not a range or something
		self.fg = fg
		self.bg = bg
		# fgs = ['black', 'red', 'green', 'blue', 'cyan', 'yellow', 'magenta']
		# bgs = ['light gray','white', 'black']
		self.width = width														# Essential and programmable
		self.height = height													# Essential and programmable
		self.text_area = tk.Text(										# Essential and partially programmable
															self.window,			# fixed unless you populate more components
															wrap=tk.CHAR,			# programmable, please find some way not to let it wrap
															height=1.5*self.height, # fixed
															width=4*self.width, # fixed
															bg=self.bg,		# programmable
															fg=self.fg,					# programmable
															font=('Courier New','16','bold'),		# programmable
														)
		self.text_area.pack(expand=tk.YES, fill=tk.BOTH)				# fixed
		self.board = Board(width=self.width,height=self.height, show_next=show_next, show_grid=show_grid)	# fixed
		self.pauseStatus = False																# fixed in the beginning, state variable
		self.window.bind("<Up>",self.rotate_CW)									# semi-fixed: change by providing a new
		self.window.bind("<Down>",self.rotate_AntiCW)						# callback: this is true of all the callbacks
		self.window.bind("<Left>",self.move_left)								# callback
		self.window.bind("<Right>",self.move_right)							# callback
		self.window.bind("<space>",self.drop_piece)							# callback
		self.window.bind("<Enter>", self.speed_up_event)												# callback
		self.update_duration = 100		# Progrmmable, and its progression too
		self.window.after(self.update_duration, lambda: self.update_step())	# callback
		self.move_down_duration = int(1000/speed_up)														# Progrmmable, and its progression too
		# self.set_difficulty(difficulty)
		self.window.after(self.move_down_duration, lambda: self.move_down_step()) # callback
		self.default_cursor = (0,int(self.board.width/2-1))			# Programmable. Where the new piece appears
		self.cursor = self.default_cursor												# State variable.
		
		self.dist = dist
		self.next = None
		self.text_area.tag_config('hello', foreground='red', background=self.bg)
		self.new_piece(dist=self.dist)
		self.text_area.insert(tk.END, self.render(), 'hello')
		self.create_menu()
		self.window.mainloop()
	
	# Each of the methods below are programmable (replaceable) -- but give in the documentation
	# what the game programmer has to provide -- the functionality, role, the entagling of concerns.
	def render(self):
		area = deepcopy(self.board)
		piece = self.piece
		for row in range(self.piece.matrix.shape[0]):
			for column in range(self.piece.matrix.shape[1]):
				if self.piece.matrix[row][column] : area.area[row+self.cursor[0]][column+self.cursor[1]] = True
		return str(area)
	
	def toggle_pause_status(self):
		self.pauseStatus = not(self.pauseStatus)
	
	def rotate_CW(self, event):
		newpiece = Shape(self.piece.matrix)
		newpiece.rotateCW()
		if self.board.collision(newpiece.matrix,self.cursor):
			return False
		else:
			self.piece = newpiece
			return True
	
	def rotate_AntiCW(self, event):
		newpiece = Shape(self.piece.matrix)
		newpiece.rotateAntiCW()
		if self.board.collision(newpiece.matrix,self.cursor):
			return False
		else:
			self.piece = newpiece
			return True
	
	def move_left(self, event):
		self.move_piece(0)
	
	def move_right(self, event):
		self.move_piece(2)
	
	def drop_piece(self, event):
		while self.move_piece(3):
			pass # Could be: nothing = "doing" # keep dropping
	
	def move_down_step(self):
		if not(self.move_piece(3)):
			self.board.insertShape(self.piece.matrix,self.cursor[0],self.cursor[1])
			self.cursor = self.default_cursor
			self.new_piece(dist=self.dist)
		tobedeleted = [row for row in reversed(range(self.height)) if all(self.board.area[row])]
		if tobedeleted:
			for row in reversed(tobedeleted):
				for newrow in reversed(range(row)):
					for column in range(self.width):
						self.board.area[newrow+1][column] = self.board.area[newrow][column]
			for row in range(len(tobedeleted)):
				self.board.area[row] = numpy.full_like(self.board.area[row],False)
		self.window.after(self.move_down_duration, lambda: self.move_down_step())
	
	def update_step(self):
		if self.pauseStatus:
			self.window.after(self.update_duration, lambda: self.update_step())
			return
		self.text_area.delete(1.0,tk.END)
		self.text_area.insert(tk.END,self.render())
		if self.board.collision(self.piece.matrix,self.cursor):
			string_board = self.render().split('\n')
			string_board[int(self.height/5)] = 'Game Over'
			lastmessage = ""
			for row in range(self.height):
				lastmessage = lastmessage + string_board[row].strip() + '\n'
			self.text_area.delete(1.0, tk.END)
			self.text_area.insert(1.0,lastmessage)
			self.dialog=tk.simpledialog.Dialog(self.window,"Game Over!")
			self.window.quit()
		else:
			self.window.after(self.update_duration, lambda: self.update_step())
	def display_message(self,message):
		self.text_area.insert(tk.END, f"\n{message}\n")
	
	def speed_up(self, factor=2):
		self.display_message(f"Game speed increased by {factor}x")
		self.move_down_duration = int(numpy.floor(self.move_down_duration/factor))

	def speed_up_event(self, event, factor=2):
		self.move_down_duration = int(numpy.floor(self.move_down_duration/factor))
	
	def slow_down(self, factor=1.1):
		self.move_down_duration = int(numpy.ceil(self.move_down_duration*factor))
	
	def extetricks_help(self):
		self.pauseStatus = True
		help_message = '''
			This is EXtendedTETRIckS, extensible to extetrominoes and more.
			Play it like all other tetris clones.
			Copyright (C) 2024 Ramprasad S. Joshi.
			(CS&IS Dept, BITS, Pilani K K Birla Goa Campus, GOA INDIA.)
			+91 832 2580 121. rsj [at] the bits mail id below.
			goa.bits-pilani.ac.in
			https://www.bits-pilani.ac.in/goa/ramprasad-savlaram-joshi
			Developed as a pedagogical resource for
			Birla Institute of Technology and Science, Pilani.
			'''
		self.text_area.delete(1.0,tk.END)
		self.text_area.insert(tk.END,help_message)
		tk.simpledialog.Dialog(self.window,"Click any button to continue")
		self.pasueStatus = False
	
	def create_menu(self):
		menu = tk.Menu(self.window)
		self.window.config(menu=menu)

		extetris_menu = tk.Menu(menu)
		menu.add_cascade(label="EXtendedTETRIckS", menu=extetris_menu)
		extetris_menu.add_command(label="New Game", command=self.new_game)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="Pause", command=self.toggle_pause_status)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="Speed-Up", command=self.speed_up)
		extetris_menu.add_command(label="Slow-down", command=self.slow_down)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="Save state", command=self.save_file)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="Exit", command=self.window.quit)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="Quit", command=self.window.quit)
		extetris_menu.add_separator()
		extetris_menu.add_command(label="About", command=self.extetricks_help)
	
	def new_piece(self,piece=None, dist = 0):
		gets = [get_any_extetromino, get_normal_distribution, get_uniform_distribution, get_gamma_distribution]
		if(self.next == None): 
			self.piece = Shape(gets[dist](self.extetromino_distribution))
			self.next = Shape(gets[dist](self.extetromino_distribution))
		else: 
			self.piece = self.next
			self.next = Shape(gets[dist](self.extetromino_distribution))
		
		self.board.updateNext(self.next.matrix)
	
	def new_game(self):
		self.pauseStatus = True
		self.text_area.delete(1.0, tk.END)
		self.board.area = numpy.full_like(self.board.area,False)
		self.piece = self.new_piece(dist=self.dist)
		self.text_area.insert(tk.END,self.render())
		self.cursor = self.default_cursor
		self.update_duration = self.initial_update_duration
		self.move_down_duration = self.initial_move_down_duration
		self.piece = self.new_piece(dist=self.dist)
		self.pauseStatus = False

	def save_file(self):
		file = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")])
		if file:
			with open(file, "w") as file_handler:
				file_handler.write(self.text_area.get(1.0, tk.END))
			self.window.title(f"Python Tetris Board - {file}")
    
	def set_difficulty(self, difficulty):
		# if increase_rotations:
		# 	self.rotations_limit = max(0, self.rotations_limit - 1)
		# if decrease_hold:
		# 	self.hold_limit = max(0, self.hold_limit - 1)
		max = 74
		if difficulty==1:
			max = 9
		elif difficulty==2:
			max = 25
		elif difficulty==3:
			max = 33
		elif difficulty==4:
			max = 74
		ext_dist = []
		for i in range(1,max,-1):
			ext_dist.append(i)
		for i in range(1,max):
			ext_dist.append(i)
		self.extetromino_distribution = ext_dist	
		factors = [1, 1.2, 1.5, 2]
		self.move_down_duration *= factors[difficulty-1]
		
	def move_piece(self,direction):
		if(direction==0): #LEFT
			offset = (0,-1)
		elif(direction==2): #RIGHT
			offset = (0,1)
		elif(direction==1): #UP
			offset = (-1,0)
		elif(direction==3): #DOWN
			offset = (1,0)
		if offset is not None:
			new_cursor = tuple(map(lambda a,b:a+b,self.cursor,offset))
			if self.board.collision(self.piece.matrix,new_cursor):
				return False
			else:
				self.cursor = new_cursor
				return True
		else:
			return False
    



if __name__ == "__main__":
	tetris_engine = TetrisEngine()
