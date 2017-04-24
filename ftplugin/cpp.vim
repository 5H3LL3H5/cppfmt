" ===========================================================
" cppfmt - auto format C/C++ Source for VIM
" Git Repository: https://github.com/StarAndRabbit/cppfmt.git
" Version: 0.1 Alpha
" Language: C/C++
" Author: Dai BingZhi <daibingzhi@foxmail.com>
" Last Change: 2017.04.24
" ===========================================================

" check Vim Python runtime
if !has('python')
    echo "Error:Required VIM compiled with +python"
    finish
endif

" make sure the module loaded once
if exists('g:autoformat_loaded')
    finish
else
    let g:autoformat_loaded = 1
    let s:path = expand("<sfile>:h")
    let s:pathlist = split(s:path, '/\zs')
    call remove(s:pathlist, len(s:pathlist)-1)
    let s:modpath = join(s:pathlist, '')
endif

command! -nargs=0 AutoFormatToggle call ToggleAutoFormat()

" open/close auto format
let s:autoformat = 0
function! ToggleAutoFormat()
    if s:autoformat == 0
        let s:autoformat = 1
        inoremap <enter> <c-\><c-o>:call StartAutoFormat()<enter><enter>
    else
        let s:autoformat = 0
        iunmap <c-\><c-o>:call StartAutoFormat()<enter><enter>

    endif
endfunction


" if cursor in the end of line, start format
function! StartAutoFormat()
    if col('$') == col('.')
        let l:pos = []
        call s:FormatCurrentLine()
        call add(l:pos, line('.'))
        call add(l:pos, col('$'))
        call cursor(l:pos)      " set cursor at the end of current line
    endif
endfunction

" format the current line
function! s:FormatCurrentLine()

python << EOF
import sys, vim
sys.path.append(vim.eval("s:modpath"))
from cfmter.fmt import Format

formater = Format(vim.current.line)
formater.expand_block()
formater.expand_operator( )
formater.expand_separator()
vim.current.line = formater.units.getstring()
EOF

endfunction
