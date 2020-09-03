" --------------------------------------
" recording
" --------------------------------------

" Disable recording
for num in range(0, 9)
  execute 'nnoremap q' . num . ' <Nop>'
endfor

for num in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap q' . nr2char(num) . ' <Nop>'
endfor

for num in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap q' . nr2char(num) . ' <Nop>'
endfor
