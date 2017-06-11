function! s:AutoHighlightWord()
  silent! call s:ClearMatches()

  if get(b:, 'auto_highlight_disabled') == 1
    return
  endif

  let s:word = expand('<cword>')

  if match(s:word, '\w\+') >= 0 && len(s:word) > 1
    let s:escaped_word = substitute(s:word, '\(*\)', '\\\1', 'g')
    call add(w:highlight_ids, matchadd('AutoHighlightWord', '\<'.s:escaped_word.'\>', 0))
  endif
endfunction

function! s:ClearMatches()
  if !exists('w:highlight_ids')
    let w:highlight_ids = []
  endif

  let ids = w:highlight_ids

  while !empty(ids)
    silent! call matchdelete(remove(ids, -1))
  endwhile
endfunction

function! s:SkipDisabledFiletypes()
  let disabled_filetypes = get(g:, 'auto_highlight#disabled_filetypes', [])

  if index(disabled_filetypes, &ft) >= 0
    let b:auto_highlight_disabled = 1
  endif
endfunction

highlight! AutoHighlightWord ctermbg=236 ctermfg=NONE

augroup AutoHighlightWord
  autocmd!
  autocmd CursorHold    * call s:AutoHighlightWord()
  autocmd CursorMoved   * call s:ClearMatches()
  autocmd Syntax        * call s:SkipDisabledFiletypes()
augroup END

command! DisableAutoHighlightWord    let b:auto_highlight_disabled = 1
command! EnableAutoHighlightWord     let b:auto_highlight_disabled = 0
command! ToggleAutoHighlightWord     let b:auto_highlight_disabled = !get(b:, 'auto_highlight_disabled')

" vim:set sw=2 sts=2:
