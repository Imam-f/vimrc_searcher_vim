" Prevent loading the plugin multiple times
if exists('g:loaded_vimrc_searcher')
  finish
endif
let g:loaded_vimrc_searcher = 1

" Check dependency: fzf command-line tool (optional but good practice)
if !executable('fzf')
  echohl WarningMsg | echo "vimrc_searcher: 'fzf' command not found in PATH." | echohl None
  " Don't finish here, fzf.vim might handle it, but warn the user.
endif

" Check dependency: fzf.vim plugin (essential for this implementation)
if !exists('*fzf#run')
  echohl WarningMsg | echo "vimrc_searcher: fzf.vim plugin not detected or fzf#run() not available." | echohl None
  finish " Cannot proceed without fzf.vim's function
endif

" Define the user command
" Use -bar to allow chaining commands (e.g., SearchVimrc | echo 'Done')
command! -nargs=0 SearchVimrc call vimrc_searcher#SearchContent()

" Optional: Provide info on how to map (don't force a map)
" You can suggest this in the documentation or as a commented-out example:
" " Example mapping (user should add this to their vimrc if desired):
" nnoremap <silent> <leader>fv :SearchVimrc<CR>
