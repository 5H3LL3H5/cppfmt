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

from fmt import Format

formater = Format(vim.current.line)
formater.expand_block()
print formater.units.getstring()

EOF
endfunction
