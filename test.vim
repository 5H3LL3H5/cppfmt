" Check Vim Python Runtime
if !has('python')
    echo "Error:Required VIM compiled with +python"
    finish
endif

let s:iscomment = 0

function! GetCurrentLineLex()
let s:path = expand("<sfile>:h")
python << EOF
import sys, vim
sys.path.append(vim.eval("s:path"))

import ply.lex as lex
import cpplex

lexer = lex.lex(module=cpplex)
lexer.input(vim.current.line)

lextype = []
lexvalue = []
lexpos = []

while True:
    tok = lexer.token()
    if not tok:
        break
    lextype.append(tok.type)
    lexvalue.append(tok.value)
    lexpos.append(tok.lexpos)
print lextype
print lexvalue
EOF
endfunction
