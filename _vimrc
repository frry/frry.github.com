""""""""""""""""""""""""""""""""""""""""""""""
"   fooy 2013/9/14 1:33:40
""""""""""""""""""""""""""""""""""""""""""""""
"#### os
let os=""
if has("win32")
    let os="win"
elseif has("unix")
    let os = substitute(system("uname"),"\n", "", "")
endif
if os=="" 
    echoe "can't get OS type"
    sleep 2
endif

if has("gui_win32") 
    so $VIMRUNTIME/mswin.vim
endif
"####file
set fencs=ucs-bom,utf-8,cp936,gb18030,gb2312,gbk,big5,euc-jp,euc-kr,latin1
set ml
set mls=4
"####edit
if has("gui_running")
    set mouse=a
endif
set ai
map Y y$
set et
set sta
set sw=4
set ts=4
noremap Z J
noremap J L
noremap K H
noremap H 0
noremap L $
"#### view
if has("gui_running")
    set hlg=cn
endif
syn on
set showcmd
set ruler
set wrap
set guioptions-=T
if has("gui_running")
    if has("gui_win32")
        set guifont=
            \Consolas:h12,
            \Lucida_Console:h12,
            \Courier_New:h12,
            \Fixedsys:h12,
    elseif has("gui_gtk2")
        set guifont=
            \Bitstream\ Vera\ Sans\ Mono\ 12,
            \DejaVu\ Sans\ Mono\ 12,
            \Monospace\ 12,
    elseif has("gui_macvim")
        set guifont=
            \Monaco:h16
    endif
endif
set nofen
set stl=%<%f\ %m%r%y%=%{&ff}\|%{&fenc}\ %15.(%c,%l/%L%)\ %P
set ruf=%40(%=%y%{&ff}\|%{&fenc}\ %c,%l/%L\ %P%)
"#### search
set ic
set is
set hls
noremap <C-f>w :vim /<C-r><C-w>/ **/*.
"#### window
"frequent used
noremap <C-x>x :q<CR>
noremap <C-x><C-x> :q<CR>
noremap <C-x>u :up<CR>
noremap <C-x>s :up<CR>
"close/quit
noremap <C-x>c :q<CR>
noremap <C-x>C :q!<CR>
noremap <C-x>q :qa<CR>
noremap <C-x>Q :qa!<CR>
"switch windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-w>m :res\|:vertical res<CR>
noremap <C-w>d :windo diffthis<CR>
noremap <C-w>t :tab :vs<CR>
"quickfix
au BufReadPost quickfix setlocal nowrap
map <C-x>n :cn<CR>
map <C-x>p :cp<CR>
"#### tabpage
noremap <C-t>t :tab :sp<CR>
noremap <C-t><C-t>  <C-w>T
noremap <C-t><C-]> <C-w><C-]><C-w>T
noremap <C-t>n :tabnew<CR>
noremap <C-t>c :tabclose<CR>
noremap <C-t>h :tabp<CR>
noremap <C-t>l :tabn<CR>
noremap <C-p> :tabp<CR>
noremap <C-n> :tabn<CR>
noremap <C-S-tab> :tabp<CR>
noremap <C-tab> :tabn<CR>
"#### browse
if has("gui_running")
    if has("win32")
        nmap <C-x>o :silent !explorer "<cWORD>"<CR>
        nmap <C-x>b :silent !"%:p"<CR>
    elseif has("gui_gtk2")
        nmap <C-x>o :silent !firefox "<cWORD>"<CR>
        nmap <C-x>b :silent !firefox "%:p"<CR>
    endif
endif
"#### F-key binding
map <F2> :Sh<CR>
nmap <F3> :RanLook<CR>
map <F4> :set wrap!<CR>
imap <F4> <C-R>=strftime("%c")<CR>
nmap <silent> <F5> :NERDTreeToggle<CR>
nmap <silent> <F6> :Tlist<CR>
nmap <F11> :windo diffthis<CR>
map <F12> :Vimrc<CR>
"####custom funcs
"terminal
function! Sh()
    if has("gui_running")
        if has("win32")
            !start cmd
        endif
    endif
endfunction
command! Sh call Sh()
"pwd
noremap <Leader>d :echohl Search\|echo getcwd()<CR>
noremap <Leader>cd :cd %:p:h\|echohl Search\|echo getcwd()<CR>
noremap <Leader>ld :lcd %:p:h\|echohl Search\|echo getcwd()<CR>
"vimrc
function! Editthis()
    if has("win32")
        sp $VIM/_vimrc
    else
        sp ~/.vimrc
    endif
endfunction
command! Vimrc call Editthis()
"random colo
function! RanLook()
    let colorfiles=[]
    if empty(colorfiles)
        for f in split(globpath(&rtp,"colors/*.vim"),"\n")
            call add(colorfiles,get(matchlist(f,'\([^\\\/]*\)\.vim'),1))
        endfor
    endif
    exe "colo" get(colorfiles,localtime()%len(colorfiles))
endfunction
command! RanLook call RanLook()
"fold
function! HiFold(...)
    let tab2space=repeat(nr2char(32),&ts)
    if a:0==0
        let g:HiStr='\t\|'.tab2space
    else
        let g:HiStr=a:1
    endif
    let g:hiLen=strlen(substitute(g:HiStr, ".", "x", "g"))
    set fillchars="fold:"
    set foldmethod=expr
    set foldexpr=HiFoldExpr(v:lnum)
    set foldtext=HiFoldText()
    hi Folded term=bold cterm=bold gui=bold
    hi Folded guibg=NONE guifg=LightBlue
endfunction
function! HiFoldExpr(lnum)
    if getline(a:lnum)!~'\S'
        return "="
    endif
    let si=getline(prevnonblank(a:lnum))
    let sj=getline(nextnonblank(a:lnum+1))
    let i=HiGetHi(si)
    let j=HiGetHi(sj)
    if j==i
        return "="
    elseif j>i
        return ">" . i
    else
        return "<" . j
    endif
endfunction
function! HiGetHi(sline)
    let c=1
    while 1
        let shead='^\(' . g:HiStr . '\)\{' . string(c) . '}'
        if a:sline=~shead
            let c+=1
            continue
        endif
        break
    endwhile
    return (c)
endfunction
function! HiFoldText()
    let sLine=getline(v:foldstart)
    let tab2space=repeat(nr2char(32),&ts)
    let sLine=substitute(sLine,"\t",tab2space,"g")
    let a=(sLine=~"^" . nr2char(32))?".":"^"
    let sLine=substitute(sLine,a,"+","")
    let sLine=sLine . "  ~" . string(v:foldend-v:foldstart)
    return sLine
endfunction
command! -nargs=? HiFold call HiFold(<args>)
"default format
function! HiLook()
    let g:HiHdr='[@#$%\-+*><]'
    au BufWinEnter * sy match url /\(https\=\|ftps\=\|file\):\/\/[0-9a-zA-Z%./?=&@_+~#-]*/
    au BufWinEnter * sy match digit /\(^\|\s\)\@<=[0-9]\+\(\.[0-9]*\)\=\($\|\s\)\@=/
    au BufWinEnter * sy match tag '\(\s\|^\)\zs\([_*%#]\)\S\{-}\2\ze\(\s\|$\)'hs=s+1,he=e-1
    au BufWinEnter * sy match tag '\(\s\|^\)\zs\[\S\{-}]\ze\(\s\|$\)'hs=s+1,he=e-1
    hi link url Underlined
    hi link tag Todo
    hi link digit Title
    "level syntax
    let g:hiLevel=4
    let c=0
    while c<g:hiLevel
        let cmdstr='sy match'
        let cmdstr=cmdstr.printf(' t%d',c)
        let cmdstr=cmdstr.' /^\('.g:HiStr.'\)\{'.printf('%d',c).'}'
        let cmdstr=cmdstr.g:HiHdr.'.*$/ contains=ALL'
        exec cmdstr
        let c+=1
    endwhile
    hi link t0  ModeMsg
    hi link t1  Type
    hi link t2  Label
    hi link t3  Function
endfunction
command! HiLook call HiLook()
au BufReadPost *  if &ft==''|call HiLook()|endif
au BufNewFile *  if &ft==''|call HiLook()|endif
"run in order
RanLook
HiFold
"easy mode
command! Easy so $VIMRUNTIME/evim.vim
command! Noeasy set noim
"ctags
function Tagbuild()
    exe "!ctags -R"
endfunction
command! Tagbuild call Tagbuild()
"cscope
let g:qfh=8
if has("cscope")
    set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
    set csto=0
    set cst
    "set csverb
    if(os=="AIX")
        set csprg=$VIM/cscope
    endif
endif
function! Csadd(...)
    "silent! exe "cs kill -1"
    let cs_farg=(a:0==0)?"cscope.out":a:1
    let cs_path=simplify(getcwd() . (has("win32")?'\':'/') . cs_farg)
    let cs_file=substitute(cs_path,'^.\+[\/\\]',"","")
    let cs_dir=substitute(cs_path,'[^\/\\]\+$','','')
    if has("cscope") && filereadable(cs_farg)
        if(has("win32"))
            "exe "let $TMPDIR=$TEMP\|cs add  " . cs_path
            exe "cs add " . cs_path
        else
            exe "cs add " . cs_farg . " " . cs_dir
        endif
    endif
endfunction
function Csbuild(...)
	let ffs=map(["*.c","*.cpp","*.h","*.hpp","*.java"]+a:000,'"\"" . v:val . "\""')
    if(has("win32"))
        silent! exe "!fdir.bat ".join(ffs,",").">cscope.files"
        "silent! exe "!dir /s /b ".join(ffs,",").">cscope.files"
    else
        let iname=(g:os == "AIX")?"-name":"-iname"
        exe "!find . ".iname." ".join(ffs," -o ".iname." ").">cscope.files"
    endif
    if(has("win32"))
        "exe "let $TMPDIR=$TEMP\|!\"set TMPDIR=\\%TMP\\%&&cscope.exe -b\""
        exe "!cscope.exe -b"
    else
        exe "!" .&csprg." -b"
    endif
    call Csadd()
endfunction
command! -nargs=* Csbuild call Csbuild(<f-args>)
command! -nargs=? -complete=file Csadd call Csadd(<f-args>)
"cs find 
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
"cs find:no split
nmap <C-f>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>g :scs find g <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>c :scs find c <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>t :scs find t <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>e :scs find e <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-f>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw <C-R>=g:qfh<CR><CR>
nmap <C-f>d :scs find d <C-R>=expand("<cword>")<CR><CR>:cw <C-R>=g:qfh<CR><CR>
"mouse
function Csjump(f,split)
    let c = getchar()
    if v:mouse_win > 0
        exe v:mouse_win . "wincmd w"
        exe v:mouse_lnum
        exe "normal " . v:mouse_col . "|"
        try
            if a:split
                exe "normal " . "\<C-f>" . a:f
            else
                exe "normal " . "\<C-\>" . a:f
            endif
        catch
            echo "error or not found"
        endtry
        exe v:mouse_win . "wincmd w"
    endif
endfunction
if has("gui_macvim")
    noremap	<D-LeftMouse>  :call Csjump("g",0)<CR>
    noremap	<D-w><LeftMouse>  :call Csjump("g",1)<CR>
    noremap	<D-RightMouse>  <C-o>
    inoremap <D-LeftMouse>  <C-o>:call Csjump("g",0)<CR>
    inoremap <D-w><LeftMouse>  <C-o>:call Csjump("g",1)<CR>
    inoremap <D-RightMouse>  <C-o><C-o>
else
    noremap	<C-LeftMouse>  :call Csjump("g",0)<CR>
    inoremap <C-LeftMouse>  <C-o>:call Csjump("g",0)<CR>
    noremap	<C-w><LeftMouse>  :call Csjump("g",1)<CR>
    inoremap <C-w><LeftMouse>  <C-o>:call Csjump("g",1)<CR>
    noremap	<C-RightMouse>  <C-o>
    inoremap <C-RightMouse>  <C-o><C-o>
    inoremap <C-f><LeftMouse>  <C-o>:call Csjump("s",1)<CR>
endif
noremap	g<LeftMouse>  :call Csjump("s",0)<CR>
"auto add
Csadd
" Find file 
let g:FindIgnore = ['.swp', '.pyc', '.class', '.git', '.svn']
function! Find(...)
    if(has("win32"))
        echo "not supported on win32"
        return
    endif
    if a:0==2
        let path=a:1
        let query=a:2
    else
        let path="./"
        let query=a:1
    endif

    if !exists("g:FindIgnore")
        let ignore = ""
    else
        let ignore = " | egrep -v '".join(g:FindIgnore, "|")."'"
    endif

    let l:list=system("find ".path." -type f -iname '*".query."*'".ignore)
    let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        echo "'".query."' not found"
        return
    endif
    if l:num == 1
        exe "open " . substitute(l:list, "\n", "", "g")
    else
        let tmpfile = tempname()
        exe "redir! > " . tmpfile
        silent echon l:list
        redir END
        let old_efm = &efm
        set efm=%f
        if exists(":cgetfile")
            execute "silent! cgetfile " . tmpfile
        else
            execute "silent! cfile " . tmpfile
        endif
        let &efm = old_efm
        "Open qfx window below
        botright copen
        call delete(tmpfile)
    endif
endfunction
command! -nargs=* Find :call Find(<f-args>)
"####plugin
"taglist
if has("win32")
    let Tlist_Ctags_Cmd=$VIM . "/ctags.exe"
endif
let Tlist_Use_Right_Window = 1
"NerdTree
"let NERDTreeWinPos='left'
let NERDTreeHijackNetrw=0
if has("unix")
    let NERDTreeDirArrows=0
endif
"omnicomplete
filetype plugin on
function Ctagbuild()
    exe "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
endfunction
command! Ctagbuild call Ctagbuild()
"ctrlp
let g:ctrlp_map = '<Leader>f'
let g:ctrlp_max_files = 0
"####END
