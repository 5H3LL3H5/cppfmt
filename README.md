# CPPFMT
A Vim Plugin that can auto format C and C++ source file.

## Update

### 2017.04.13
- complete plugins path in directory, now it can auto load this plugin

### 2017.03.24
- now you can use it when you programing in Vim :) (actually it has many bugs to fixed)

### 2017.03.23
- now can format a line
- can get string after format
- reconstruct source code

### 2017.03.22
- add fsm to recognize leftblockcomment, pointer and so on ( but I have no idea to use it:( )

## Install
This plugin depends on PLY(Python Lex Yacc Library), so make sure you have install this library on your system.

You can install PLY library by using :
```Bash
pip install ply
```

## Usage
1. Source cppfmt.vim in Vim editor.
2. call ToggleAutoFormat function
```VimScript
:call ToggleAutoFormat()
```
3. When you push "Enter" in the end of a line, you will found that it will auto format this line :)
(if yout want to turn off auto format, you can call ToggleAutoFormat again)

## BUGs
- if your string like '/*' or '*/', it will be recognized as 'divide' and 'times'
- it can't recognize 'pointer', if you have a line like "``` int *v;```" the '*' will be recognized as 'times'
