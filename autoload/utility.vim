
" Print the name of the highlight group(s) of the word under the cursor
function! utility#HiInspector()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
