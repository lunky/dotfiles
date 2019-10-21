"-------------------------------------------------------------------------------
" vimrc - This file will be used for both vim and gvim ( unix + win32 )
"-------------------------------------------------------------------------------
" Only do this for Vim version 5.0 and later.
if version >= 500
hi Statement  cterm=bold ctermfg=Red        gui=bold guifg=blue
hi Type       cterm=NONE ctermfg=Red        gui=bold guifg=blue

    syntax on               " Switch on syntax highlighting.
    

    set mousehide           " Hide the mouse pointer while typing
    set nocompatible        " Don't try to be VI
    set cindent             " 'c' indenting - good for perl and java too
    set shiftwidth=4        " shift width - studies say 4 is easiest to read
    set tabstop=4           " tab stop - studies say 4 is easiest to read
    set laststatus=2        " laststatus - status bar along the bottom
    set ruler               " This is the cursor location in statusbar
    set ignorecase          " Ignores case in text searches
    set hlsearch            " Switch on search pattern highlighting.
    set visualbell          " turns off the mind bending 'binging'

    autocmd Filetype ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd Filetype coffee setlocal ts=2 sts=2 sw=2 expandtab
    autocmd Filetype haml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd Filetype elm setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType javascript setlocal commentstring=//\ %s
    
    set expandtab " lets just make this the default

    set shellpipe="|& tee "
    if has("gui_running")
        set lines=40
        set columns=195

        nmap <C-S-V> "+gP
        imap <C-S-V> <ESC><C-S-V>a
        vmap <C-S-C> "+y
    else
        "set term=screen-256color
        set mouse=a
        set ttymouse=xterm2
    endif


    highlight Normal     guibg=grey90  guifg=Black   term=NONE
    highlight Cursor     guibg=Green   guifg=NONE    ctermfg=Green  ctermbg=NONE 
    highlight NonText    gui=NONE      guibg=grey90
    highlight Constant   gui=NONE      guibg=grey90
    highlight Special    gui=NONE      guibg=grey90

    highlight StatusLine    guifg=Red  guibg=White ctermfg=Red   ctermbg=White
    highlight StatusLineNC guifg=Green guibg=Black ctermfg=Green ctermbg=Black
    highlight Search guifg=Black guibg=Yellow ctermfg=Black ctermbg=Yellow
    highlight Comment ctermfg=blue
    if has("gui_running")
        colorscheme darkblue
        " hide the toolbar
        set guioptions-=T
    endif

    " Make shift-insert work like in Xterm
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>

    nmap <S-Insert> "+gP
    imap <S-Insert> <ESC><C-S-V>a
    vmap <C-Insert> "+y

    " Map Ctrl-W to leader w 
    nnoremap <Leader>w <C-w>
    noremap <Leader>- :Commentary<cr>

    set writebackup
    "---------------------------------------------------------------------------
    " Win32 - put Win32 specific "stuff" here.
    "---------------------------------------------------------------------------
    if has("win32")
        " Fixedsys 10pt looks nice on all the windows computers I use
        set guifont=Fixedsys:h10
        set fileformat=unix     " fileformat = ff is the cr/lf issue.
        set dir=>c:\\temp\\     " temp directory, defaults to \temp I think
        set backupdir=>c:\\temp\\   " same as directory
        set shell=bash          " for commands like "make" and "shell"

        source $VIMRUNTIME/mswin.vim
        behave mswin
    else
        " This looks nices where ever I run unix'ish OS's
"       set guifont=-adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
        set backupdir=~/.tmp
        set dir=~/.tmp
    endif

    "---------------------------------------------------------------------------
    " unix - put the un*x specific "stuff" here
    "---------------------------------------------------------------------------
    if has("unix")
    endif
" got the next couple of lines from the vim mailing group c/o
" :Freddy Vulto <fvu@fvu.myweb.nl>
"   set shell=D:\\Programs\\DjGpp\\bash.bat
"set shell=c:\\programs\\cygwin\\bash.bat
   set shellcmdflag=-c
"   set shellredir=>%s\ 2>&1
   set shellredir=">%s 2>&1"
   set shellxquote=\"
   set ssl


endif

"set writebackup
" Sourse the .exrc "Mappings"
" :source ~/.exrc
set nowrap
set runtimepath^=~/.vim/bundle/node
set runtimepath^=~/.vim/bundle/vim-nodejs-errorformat

set number " line numbers
if &term =~ '^xterm'
  " solid underscore
  let &t_SI .= "\<Esc>[4 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

" Shortcut to rapidly toggle `set list`
   nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:?\ ,eol:¬


" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

execute pathogen#infect()
