import ply.lex as lex

class LexicalUnit():

    def __init__(self, type, value, line, pos):
        self.type = type
        self.value = value
        self.line = line
        self.pos = pos


class Lexicon():

    def __init__(self, lexer):
        
        self.__units = []
        self.__counter = 0
        
        while True:
            tok = lexer.token()
            if not tok:
                break;
            self.__units.append(LexicalUnit(tok.type, tok.value, tok.lineno, tok.lexpos))

    def __iter__(self):
        return self

    def next(self):
        if self.__counter < len(self.__units):
            unit = self.__units[self.__counter]
            self.__counter += 1
            return unit
        else:
            raise StopIteration

    def __len__(self):
        return len(self.__units)