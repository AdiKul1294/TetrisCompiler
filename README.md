# Tetris Compiler

## How to Run

1. Make sure you have `Flex` and `Bison` installed.
2. Open a terminal and navigate to the directory containing the source files.
3. Type `make build<tc_num>` to compile the compiler and run the tetris game on the particular testcase.
5. 3 testcases have been provided in the files named `tc1.tetris`, `tc2.tetris` and `tc3.tetris` which display various inputs given to the compiler.

## Semantics

This Tetris compiler allows game programmers to define various features of the Tetris game. Here are the available features and their corresponding commands:

1. **Forward Color (`fg`):** Sets the color of the Tetris blocks. Can choose from ["black", "red", "green", "blue", "cyan", "yellow", "magenta"]
2. **Background Color (`bg`):** Sets the background color of the Tetris game. Can choose from ['"light gray","white", "black"]
3. **See Next Tetromino (`show_next`):** Displays the next Tetris piece that will appear.
4. **Speed Increase Factor (`speed_up`):** Adjusts the speed at which the Tetris pieces fall.
5. **Height (`height`):** Sets the height of the Tetris game board.
6. **Width (`width`):** Sets the width of the Tetris game board.
7. **Distribution (`dist`):** Sets the probability distribution of Tetris pieces. Mapping: 1-Random, 2-Normal, 3-Uniform, 4-Gamma
8. **Show Next Piece (`show_next`):** Toggle showing the next piece on/off. Need to pass True/False accordingly.
9. **Show Grid (`show_grid`):** Toggle showing the grid. Need to pass True/False accordingly.
10. **Extetromino List (`extetromino_distribution`):** Sets the list of extetrominos to choose from. Needs to be an array of integers >=1. To change frequency of extetrominos, user can pass multiple elements of that piece in this list.

---
# TetScript

TetScript is a domain-specific language designed for programming Tetris game behaviors and configurations.

## Overview

TetScript allows game programmers to define various aspects of the Tetris game, including primitives, functions, and engine configurations.

## Syntax
Each new line of the script must be seperated by '#'.

### Sections

A TetScript program consists of three main sections:

1. **Section 1:** Primitive Declarations
2. **Section 2:** Function Definitions
3. **Section 3:** Engine Configuration

Each section is delineated by a keyword followed by a newline.

#### Section 1: Primitive Declarations

In this section, you can define primitive variables and their initial values. This is essentially for **global variable initialisations**.

Example:
```
score = 0
speed = 1.5
```

#### Section 2: Function Definitions
User must provide a function named 'mainFunc' which is the starting point of the execution of code. **Without this the code will not run**

Functions in TetScript are defined with the following syntax:

```
{ function_name statement1 statement2 ... }
```

If the function has any input parameters it should be initialised as follows:
```
{ function_name with (param1 param2) statement1 statement2 ...}
```

Example:
```
{setShowNext show_next = 1}
#
{ mainFunc speed = [call setShowNext] }
```

#### Section 3: Engine Configuration

This section configures the Tetris game engine, including the main function and any additional setup.

Example:
```
[ play with difficulty=difficulty fg=fg_color show_next=show_next]
```

### Statements

TetScript supports various statements within function bodies, including:

- **Assignment:** Assigning values to variables.
- **Control Flow:** `if`, `then`, `else`, `end`, `while` statements for conditional and loop execution.
- **Function Calls:** Calling defined functions.

### Function Calling

Function calling can be done in two ways:
1. Calling without any params: ```[call <func_name>]```
2. Calling with params: ```[call <func_name> with param1=value1 param2=value2 ...]```


### Keywords

TetScript reserves keywords for language constructs:

- `if`, `then`, `else`, `end`, `while`: Control flow keywords.
- `call`, `with`: Function call and parameter passing keywords.
- `or`, `and`, `not`: Logical operators.
- `neg`: Negation operator.
- `play`: Engine configuration keyword.

### Identifiers

Identifiers are used to name variables and functions. They must start with a letter and can contain letters, digits, and underscores.

### Numbers

TetScript supports integer and floating-point numbers.

### Strings

TetScript supports Strings. They are of the form "This is a String"

### Lists

TetScript supports Lists of Strings and Numbers. They must be enclosed in {}

## Testcase-1

To run this testcase execute the command `make build1` in terminal.

```
Section1
#
fg_color="green"
#
bg_color="black"
#
speed_increase_factor=1
#
show_grid=False
#
show_next=False
#
extetromino_distribution={3,2,2,1,1,1,2,2,3}
#
Section2
#
{ setGrid show_grid=True }
#
{ setFg with (color) fg_color=color}
#
{ mainFunc x = [call setGrid] y=[call setFg with color="red"]}
#
Section3
#
[ play with fg=fg_color bg=bg_color show_next=show_next dist=1 extetromino_distribution=extetromino_distribution show_grid=show_grid]

```

## Testcase-2

To run this testcase execute the command `make build2` in terminal.

```
Section1
#
fg_color="green"
#
bg_color="white"
#
speed_increase_factor=1
#
speed_decrease_factor=1
#
show_grid=False
#
show_next=True
#
extetromino_distribution={1,2,3}
#
Section2
#
{ setDifficulty with (diff speed) if(diff=1) then extetromino_distribution={3,2,2,1,1,1,2,2,3} speed_increase_factor=speed end}
#
{ mainFunc [call setDifficulty with diff=2 speed=1.2] }
#
Section3
#
[ play with fg=fg_color bg=bg_color show_next=show_next dist=1 extetromino_distribution=extetromino_distribution show_grid=show_grid move_down_duration=1000*speed_increase_factor]

```

## Testcase-3

To run this testcase execute the command `make build3` in terminal.

```
Section1
#
fg_color="green"
#
bg_color="black"
#
speed_increase_factor=1
#
show_grid=False
#
show_next=False
#
extetromino_distribution={3,2,2,1,1,1,2,2,3}
#
height = 0
#
width = 0
#
Section2
#
{ showNext show_next=True}
#
{ incSpeed i=1 while(i<10) speed_increase_factor=speed_increase_factor+0.1 i=i+1 end}
#
{ mainFunc [call showNext] [call incSpeed] }
#
Section3
#
[ play with fg=fg_color bg=bg_color show_next=show_next dist=1 extetromino_distribution=extetromino_distribution show_grid=show_grid speed_up=speed_increase_factor]

```

## Conclusion

This README provides an overview of TetScript syntax and structure. With this knowledge, you can start writing and experimenting with Tetris game behaviors and configurations using TetScript.

## Acknowledgment

This project also utilizes the skeletal parser structure developed by Ramprasad S. Joshi durng the course CS F363 - Compiler Construction in BITS Pilani K K Birla Goa Campus.

This project utilizes code from **engine.py, board.py, allextetrominos.py, shape.py: A Programmable Tetris-like Games Engine** developed by Ramprasad S. Joshi. The engine is distributed under the terms of the GNU General Public License (GPL) version 3 or any later version. I express my gratitude to Ramprasad S. Joshi for their contribution to open-source software development.

For more information about the GNU General Public License, please visit [here](https://www.gnu.org/licenses/).

---

