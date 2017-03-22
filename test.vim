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

from lexicon import Lexicon
import fsms

lexer = lex.lex(module=cpplex)
lexer.input(vim.current.line)

units = Lexicon(lexer)

for unit in units:
    print unit.type

EOF
endfunction
