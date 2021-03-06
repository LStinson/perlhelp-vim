" vim600: set foldmethod=marker:
" =============================================================================
" File:         perlhelp.vim (global plugin)
" Last Changed: Thu Oct 31 06:07 PM 2013 EDT
" Maintainer:   Jessica McIntosh <JessicaKMcIntosh@gmail.com>
" Version:      1.7
" License:      Vim License
" Webite:       https://github.com/JessicaKMcIntosh/perlhelp-vim
" =============================================================================

" Change Log: {{{1

" 1.6 2012-01-10
" Cleanup and reformatting.
" Moved to GitHub: http://github.com/LStinson/perlhelp-vim

" 1.5 2007-06-22
" Added variable lookup.
" Load man pages to the respective topics when no topic is specified.

" 1.4 2007-06-22
" When lookup up a function strip everything up to, and including, '->'.
" This will make methods be looked up instead of the object the method is
" called from.

" 1.3 2007-06-15
" Set the file type to man if viewing general perldoc output.

" 1.3 2007-06-14
" Improved handling of the results form <cWORD> and combined the handler
" functions for PerlHelp, PerlMod \ph and \pm into one.

" 1.2 2007-06-14
"   Removed 'setlocal iskeyword+=:' and used <cWORD> and a substitution
"   as suggested by Erik Falor.

" 1.1 2007-06-13
"   Added 'setlocal iskeyword+=:' to account for :'s in module names.

" }}}1

" Initialization: {{{1
" Allow user to avoid loading this plugin and prevent loading twice.
if exists('loaded_perlhelp')
    finish
endif

let loaded_perlhelp = 1

" Make sure perldoc is available and executable
if exists('perlhelp_prog')
    let s:perlhelp = perlhelp_prog
else
    let s:perlhelp = 'perldoc'
endif
if !exists('perlhelp_no_check') && !executable(s:perlhelp)
  echoe 'perldoc is not installed!'
  finish
endif
let s:perlhelp = s:perlhelp . ' -T -t '
" }}}1

" Commands: {{{1
:command! -nargs=? PerlFAQ  call <SID>PerlHelpFAQ(<f-args>)
:command! -nargs=? PerlFunc call <SID>PerlHelpFunc(<f-args>)
:command! -nargs=? PerlHelp call <SID>PerlHelp('topic', '', <f-args>)
:command! -nargs=? PerlMod  call <SID>PerlHelp('module', '-m', <f-args>)
:command! -nargs=? PerlVar  call <SID>PerlHelpVar(<f-args>)
" }}}1

" Key Mappings: {{{1
if !hasmapto('<Plug>PerlHelpNormal')
    nmap <silent> <unique> <Leader>ph <Plug>PerlHelpNormal
endif
if !hasmapto('<Plug>PerlHelpVisual')
    vmap <silent> <unique> <Leader>ph <Plug>PerlHelpVisual
endif
if !hasmapto('<Plug>PerlHelpAsk')
    nmap <silent> <unique> <Leader>PH <Plug>PerlHelpAsk
endif
if !hasmapto('<Plug>PerlHelpFuncNormal')
    nmap <silent> <unique> <Leader>pf <Plug>PerlHelpFuncNormal
endif
if !hasmapto('<Plug>PerlHelpFuncVisual')
    vmap <silent> <unique> <Leader>pf <Plug>PerlHelpFuncVisual
endif
if !hasmapto('<Plug>PerlHelpFuncAsk')
    nmap <silent> <unique> <Leader>PF <Plug>PerlHelpFuncAsk
endif
if !hasmapto('<Plug>PerlHelpModNormal')
    nmap <silent> <unique> <Leader>pm <Plug>PerlHelpModNormal
endif
if !hasmapto('<Plug>PerlHelpModVisual')
    vmap <silent> <unique> <Leader>pm <Plug>PerlHelpModVisual
endif
if !hasmapto('<Plug>PerlHelpModAsk')
    nmap <silent> <unique> <Leader>PM <Plug>PerlHelpModAsk
endif
if !hasmapto('<Plug>PerlHelpFAQNormal')
    nmap <silent> <unique> <Leader>pq <Plug>PerlHelpFAQNormal
endif
if !hasmapto('<Plug>PerlHelpFAQVisual')
    vmap <silent> <unique> <Leader>pq <Plug>PerlHelpFAQVisual
endif
if !hasmapto('<Plug>PerlHelpFAQAsk')
    nmap <silent> <unique> <Leader>PQ <Plug>PerlHelpFAQAsk
endif
if !hasmapto('<Plug>PerlHelpVarNormal')
    nmap <silent> <unique> <Leader>pv <Plug>PerlHelpVarNormal
endif
if !hasmapto('<Plug>PerlHelpVarVisual')
    vmap <silent> <unique> <Leader>pv <Plug>PerlHelpVarVisual
endif
if !hasmapto('<Plug>PerlHelpVarAsk')
    nmap <silent> <unique> <Leader>PV <Plug>PerlHelpVarAsk
endif
" }}}1

" Plug Mappings: {{{1
nmap <silent> <unique> <script> <Plug>PerlHelpNormal      :call <SID>PerlHelp('topic', '', expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpVisual     y:call <SID>PerlHelp('topic', '', '<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpAsk         :call <SID>PerlHelp('topic', '')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFuncNormal  :call <SID>PerlHelpFunc(expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpFuncVisual y:call <SID>PerlHelpFunc('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFuncAsk     :call <SID>PerlHelpFunc()<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpModNormal   :call <SID>PerlHelp('module', '-m', expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpModVisual  y:call <SID>PerlHelp('module', '-m', '<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpModAsk      :call <SID>PerlHelp('module', '-m')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFAQNormal   :call <SID>PerlHelpFAQ(expand("<cword>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpFAQVisual  y:call <SID>PerlHelpFAQ('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFAQAsk      :call <SID>PerlHelpFAQ()<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpVarNormal   :call <SID>PerlHelpVar(expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpVarVisual  y:call <SID>PerlHelpVar('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpVarAsk      :call <SID>PerlHelpVar()<CR>
" }}}1

" Functions:

" Ask for text to lookup. {{{1
function <SID>PerlHelpAsk(prompt)
    let l:string = input('Enter the ' . a:prompt . ' to lookup: ')
    return l:string
endfunction " }}}1

" Display help on a perl FAQ entry. {{{1
function <SID>PerlHelpFAQ(...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk('FAQ regular expression')
    else
        let l:topic = a:1
    endif

    " Get the text and set the syntax type.
    if l:topic != ''
        let l:topic = escape(l:topic, '"\')
        let l:text = system(s:perlhelp . ' -q "' . l:topic . '"')
        let l:type = 'text'
    else
        let l:text = system(s:perlhelp . " perlfaq")
        let l:type = 'man'
    endif

    " Display the text.
    call <SID>PerlHelpWindow(l:text, l:type)
endfunction " }}}1

" Display help on a perl variable. {{{1
function <SID>PerlHelpVar(...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk('variable')
    else
        " Try to capture a variable.
        " This can be tricky since variables use some strange punctuation.
        " The following formats are tried in order.
        " $, % or @ followed by alpha numeric characters and _.
        " $, % or @ followed by ^ then a single alpha numeric character.
        " $, % or @ followed by a single character.
        " This should catch all special perl variables.
        let l:topic = substitute(a:1, '^[^$%@]*\([$%@]\([[:alnum:]_]\+\|^[[:alnum:]]\|.\)\).*', '\1', '')
    endif

    " Display the perlvar page.
    let l:text = system(s:perlhelp . " perlvar")
    call <SID>PerlHelpWindow(l:text, 'man')

    " Find the variable they want to lookup.
    if l:topic != ''
        let l:topic = escape(l:topic, '\')
        execute "/^  \\+\\M" . l:topic . "/"
    endif
endfunction " }}}1

" Display help on a perl function. {{{1
function <SID>PerlHelpFunc(...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk('function')
    else
        " Try to eliminate the package or variable if it's a method.
        let l:topic = substitute(a:1, '^.*->', '', 'g')
        " Remove any non alpha numeric characters with an optional leading hyphen.
        let l:topic = substitute(l:topic, '^[^[:alnum:]\-]*\(-\=[[:alnum:]]*\).*', '\1', 'g')
    endif

    " Get the text and set the syntax type.
    if l:topic != ''
        let l:text = system(s:perlhelp . " -f " . l:topic)
        let l:type = 'text'
    else
        let l:text = system(s:perlhelp . " perlfunc")
        let l:type = 'man'
    endif

    " Display the text.
    call <SID>PerlHelpWindow(l:text, l:type)
endfunction " }}}1

" Lookup a module or general topic. {{{1
" question is the question to as if no topic is supplied.
" option is currently only used for looking up module source.
function <SID>PerlHelp(question, option, ...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk(a:question)
    else
        " Only grab soemthing that could be a topic or module.
        let l:topic = substitute(a:1, '^[^[:alnum:]_:]*\([[:alnum:]_:]*\).*', '\1', 'g')
        " Eliminate trailing -'s.
        let l:topic = substitute(l:topic, '-*$', '', '')
    endif

    " Try to lookup the topic.
    if l:topic != ''
        while 1
            let l:text = system(s:perlhelp . a:option . ' ' . l:topic)
            if l:text =~ '^No [[:alpha:]]* found for'
                " The module was not found.
                " Try stripping off the last bit.
                if l:topic =~ '::'
                    " Strip off the last bit of the module.
                    " eg. Getopt::Std::STANDARD_HELP_VERSION becomes Getopt::Std
                    let l:topic = substitute(l:topic, '::[^:]*$', '', '')
                else
                   " No more to strip off, give up.
                   break
                endif
            else
                " Found the module.
                break
            endif
        endwhile
    else
        let l:text = system(s:perlhelp . " perl")
    endif

    " Setup the syntax highlighting method used.
    if a:option == '-m'
        if l:text =~ '^No [[:alpha:]]* found for'
            let l:type = 'text'
        else
            let l:type = 'perl'
        endif
    else
        let l:type = 'man'
    endif

    " Display the text.
    call <SID>PerlHelpWindow(l:text, l:type)
endfunction " }}}1

" Display the actual text. {{{1
" Split the window or use the existing split to display the text.
" Taken from asciitable.vim by Jeffrey Harkavy.
function <SID>PerlHelpWindow(command, syntax)
    let s:height = 19
    let s:winnum = bufnr('__PerlHelp__')
    if getbufvar(s:winnum, 'PerlHelp') == 'PerlHelp'
        let s:winnum = bufwinnr(s:winnum)
    else
        let s:winnum = -1
    endif
    
    if s:winnum >= 0
        " if already exist
        if s:winnum != bufwinnr('%')
          exe "normal! \<c-w>" . s:winnum . 'w'
        endif
        setlocal modifiable
        silent %d _
    else
        execute s:height . 'split __PerlHelp__'
        setlocal noswapfile
        setlocal buftype=nowrite
        setlocal bufhidden=delete
        setlocal nonumber
        setlocal nowrap
        setlocal norightleft
        setlocal foldcolumn=0
        setlocal nofoldenable
        setlocal modifiable
        let b:PerlHelp='PerlHelp'
    endif

    silent put! =a:command
    setlocal nomodifiable
    1 " Skip to the top of the text.
    " Set the syntax for the file.
    if a:syntax != ''
        execute "set ft=" . a:syntax
    else
        set ft=text
    endif
endfunction " }}}1
