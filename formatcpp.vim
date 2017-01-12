" GetLineNums
" 生成当前缓冲区文件行号列表
"
" return: 文件行号列表
"
function! formatcpp#GetLineNums()
    return range(1, line('$'))
endfunction

" RemoveFromStr
" 从字符串中删除指定字符
"
" str: 源字符串
" waitforrm: 目标字符串或列表
" 
" return: 删除目标字符串后的字符串
" 
function! formatcpp#RemoveFromStr(str, waitforrm)
    if type(a:waitforrm) == type("")
        return substitute(a:str, a:waitforrm, "", '')
    elseif type(a:waitforrm) == type([])
        let l:str = a:str
        for l:s in a:waitforrm
            let l:str = substitute(l:str, l:s, "", '')
        endfor
        return l:str
    else
        return a:str
    endif
endfunction

" FormatIndent
" 格式化缩进
"
function! formatcpp#FormatIndent()
    normal gg=G
endfunction

" GetBlockCommentLineNums
" 获取块注释的行号
"
" return: 行号列表
"
function! formatcpp#GetBlockCommentLineNums()
    let l:commentflag = 0
    let l:commentlist = []
    
    for l:linenum in formatcpp#GetLineNums()
        let l:line = getline(l:linenum)
        if l:commentflag == 0
            if match(l:line, '\v\/\*') != -1
                let l:commentflag = 1
                continue
            endif
        else
            if match(l:line, '\v\*\/') != -1
                let l:commentflag = 0
                continue
            endif
            call add(l:commentlist, l:linenum)
        endif
    endfor

    return l:commentlist
endfunction

" GetPreProcessLineNums
" 获取预处理行的行号
" 
" return: 预处理行的行号列表
"
function! formatcpp#GetPreProcessLineNums()
    let l:preprocesslist = []

    for l:linenum in formatcpp#GetLineNums()
        let l:line = getline(l:linenum)
        if match(l:line, '\v^\#') != -1
            call add(l:preprocesslist, l:linenum)
        endif
    endfor
    
    return l:preprocesslist
endfunction

" GetMatchesList
" 获取匹配项的列表
"
" str: 源字符串
" pat: 匹配模式
"
" return: 匹配项列表
"
function! formatcpp#GetMatchesList(str, pat)
    let l:str = a:str
    let l:matcheslist = []
    let l:start = match(l:str, a:pat)

    while l:start != -1
        let l:end = matchend(l:str, a:pat)
        let l:len = l:end - l:start
        call add(l:matcheslist, '\V' . strpart(l:str, l:start, l:len))
        let l:str = formatcpp#RemoveFromStr(l:str, '\V' . strpart(l:str, l:start, l:len))
        let l:start = match(l:str, a:pat)
    endwhile

    return l:matcheslist
endfunction

" GetLineNumsNeedFormat
" 获取需要格式化的行号
"
" return: 需要格式化的行号
"
function! formatcpp#GetLineNumsNeedFormat()
    let l:linenums = formatcpp#GetLineNums()
    let l:commentnums = formatcpp#GetBlockCommentLineNums()
    let l:preprocessnums = formatcpp#GetPreProcessLineNums()
    for l:commentnum in l:commentnums
        call filter(l:linenums, 'v:val != ' . l:commentnum)
    endfor
    for l:preprocessnum in l:preprocessnums
        call filter(l:linenums, 'v:val != ' . l:preprocessnum)
    endfor
    return l:linenums
endfunction

function! formatcpp#Format()
    for l:linenum in formatcpp#GetLineNumsNeedFormat()
        let l:line = getline(l:linenum)
        let l:line = formatcpp#RemoveFromStr(l:line, formatcpp#GetMatchesList(l:line, '\v\/\/.*|\/\*.*|.*\*\/|\".{-}\"'))
        let l:addspace2side = formatcpp#GetMatchesList(l:line, '\v\s*(\+|\-|\*|\/|\%|\=|\=\=|\!\=|\>|\<|\>\=|\<\=|\&\&|\|\||\&|\||\^|\<\<|\>\>|\+\=|\-\=|\*\=|\/\=|\%\=|\<\<\=|\>\>\=|\&\=|\|\=|\^\=)\s*')
        let l:line = formatcpp#RemoveFromStr(l:line, l:addspace2side)
        let l:addspacer = formatcpp#GetMatchesList(l:line, '\v\s*(\(|\,|\;)\s*')
        let l:line = formatcpp#RemoveFromStr(l:line, l:addspacer)
        let l:addspacel = formatcpp#GetMatchesList(l:line, '\v\s*(\)|\!|\~)\s*')
        let l:line = formatcpp#RemoveFromStr(l:line, l:addspacel)
        
        let l:newspace2side = []
        for l:str in l:addspace2side
        endfor

    endfor
endfunction
