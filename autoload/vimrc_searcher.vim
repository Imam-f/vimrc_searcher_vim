" Function to perform the search
function! vimrc_searcher#SearchContent() abort
  " Check if $MYVIMRC is set and points to a readable file
  if empty($MYVIMRC) || !filereadable(expand($MYVIMRC))
    echohl ErrorMsg
    echo "Error: $MYVIMRC is not set or file is not readable: " . getenv('MYVIMRC')
    echohl None
    return
  endif

  " Read the file content and prepend line numbers
  let s:lines_with_numbers = map(readfile($MYVIMRC), {idx, val -> printf('%4d: %s', idx + 1, val)})

  " Check if fzf.vim is available *just before* running
  if !exists('*fzf#run')
    echohl ErrorMsg | echo "Error: fzf.vim function fzf#run() not found." | echohl None
    return
  endif

  " Run fzf
  call fzf#run({
        \ 'source': s:lines_with_numbers,
        \ 'sink': function('vimrc_searcher#JumpToLine'),
        \ 'options': '--prompt "Search Config > " --layout=reverse --border --height 40%',
        \ 'down': '40%',
        \ })
endfunction

" Function called when a line is selected in FZF
function! vimrc_searcher#JumpToLine(selected_line) abort
  " Extract the line number
  let l:line_number_str = matchstr(a:selected_line, '^\s*\zs\d\+')

  if empty(l:line_number_str)
    echohl ErrorMsg
    echo "Error: Could not extract line number from: " . a:selected_line
    echohl None
    return
  endif

  let l:line_number = str2nr(l:line_number_str)

  if l:line_number <= 0
    echohl ErrorMsg
    echo "Error: Invalid line number extracted: " . l:line_number
    echohl None
    return
  endif

  " Open the vimrc file and jump to the specific line
  try
    execute 'keepalt edit +' . l:line_number . ' ' . fnameescape($MYVIMRC)
    " Optional: Center the view on the jumped line
    normal! zz
  catch
    echohl ErrorMsg
    echo "Error opening or jumping in $MYVIMRC: " . v:exception
    echohl None
  endtry
endfunction
