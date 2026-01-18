if &compatible
  set nocompatible
endif

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

filetype plugin indent on

autocmd!

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim), for a commit or rebase message
" (likely a different one than last time), and when using xxd(1) to filter
" and edit binary files (it transforms input files back and forth, causing
" them to have dual nature, so to speak) or when running the new tutor
autocmd BufReadPost *
  \ let line = line("'\"")
  \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
  \      && index(['xxd', 'gitrebase', 'tutor'], &filetype) == -1
  \      && !&diff
  \ |   execute "normal! g`\""
  \ | endif

" Set the default background for putty to dark. Putty usually sets the
" $TERM to xterm and by default it starts with a dark background which
" makes syntax highlighting often hard to read with bg=light
" undo this using:  ":au! vimStartup TermResponse"
autocmd TermResponse * if v:termresponse == "\e[>0;136;0c" | set bg=dark | endif

" Quite a few people accidentally type "q:" instead of ":q" and get confused
" by the command line window.  Give a hint about how to get out.
" If you don't like this you can put this in your vimrc:
" ":autocmd! vimHints"
autocmd CmdwinEnter *
  \ echohl Todo |
  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
  \ echohl None

syntax on

command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis

if has('langmap') && exists('+langremap')
  set nolangremap
endif
