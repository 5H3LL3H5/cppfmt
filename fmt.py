import ply.lex as lex
import cpplex
from lexicon import Lexicon

class Format():
    __operator = (
            'PLUS', 'MINUS', 'TIMES', 'DIVIDE', 'MOD',
            'OR', 'AND', 'NOT', 'XOR', 'LSHIFT', 'RSHIFT',
            'LOR', 'LAND', 'LNOT',
            'LT', 'LE', 'GT', 'GE', 'EQ', 'NE',
            'EQUALS', 'TIMESEQUAL', 'DIVEQUAL', 'MODEQUAL', 'PLUSEQUAL', 'MINUSEQUAL',
            'LSHIFTEQUAL', 'RSHIFTEQUAL', 'ANDEQUAL', 'XOREQUAL', 'OREQUAL', )
    __lblock = ( 'LPAREN', 'LBARACKET', 'LBRACE', )
    __rblock = ( 'RPAREN', 'RBARACKET', 'RBRACE', )
    __block = __lblock + __rblock

    # block expand style
    BLKINNER = 0
    BLKOUTTER = 1
    BLKALL = 2

    def __init__(self, originstring):
        self.originstring = originstring
        self.lexer = lex.lex(module = cpplex)
        self.lexer.input(originstring)
        self.units = Lexicon(self.lexer)

    def __flushlexicon(self):
        self.lexer.input(self.units.getstring())
        self.units = Lexicon(self.lexer)

    def expand_operator(self):
        for index in range(len(self.units)):
            if self.units[index].type in self.__operator:
                if index != 0 and self.units[index-1].type != 'SPACE':
                    self.units[index].value = ' ' + self.units[index].value
                if index != (len(self.units)-1) and self.units[index+1].type != 'SPACE' and self.units[index].type != 'NOT' and self.units[index].type != 'LNOT':
                    self.units[index].value += ' '
        self.__flushlexicon()

    def __expand_blkinner(self):
        for index in range(len(self.units)):
            if self.units[index].type in self.__lblock:
                if index != (len(self.units)-1) and self.units[index+1].type != 'SPACE':
                    self.units[index].value += ' '
        self.__flushlexicon()
        for index in range(len(self.units)):
            if self.units[index].type in self.__rblock:
                if index != 0 and self.units[index-1].type != 'SPACE':
                    self.units[index].value = ' ' + self.units[index].value
        self.__flushlexicon()

    def __expand_blkoutter(self):
        for index in range(len(self.units)):
            if self.units[index].type in self.__lblock:
                if index != 0 and self.units[index-1].type != 'SPACE':
                    self.units[index].value = ' ' + self.units[index].value
            if self.units[index].type in self.__rblock:
                if index != (len(self.units)-1) and self.units[index+1].type != 'SPACE':
                    self.units[index].value += ' '
        self.__flushlexicon()

    def __expand_blkall(self):
        self.__expand_blkinner()
        self.__expand_blkoutter()

    def expand_block(self, style = 0):
        switcher = { self.BLKINNER:self.__expand_blkinner,
                self.BLKOUTTER:self.__expand_blkoutter,
                self.BLKALL:self.__expand_blkall }
        func = switcher.get(style)
        func()
