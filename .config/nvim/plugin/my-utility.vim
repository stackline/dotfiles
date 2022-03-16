" TODO: Consider whether to make it a vim plugin

" Utility
function! GetURLComponents()
  let l:remote_url = system('git remote get-url origin | tr -d "\n"')
  let l:components = split(l:remote_url, '/')

  " scheme
  let l:scheme = 'https'

  " authority
  let l:authority = l:components[2]

  if match(l:authority, '@') >= 1
    let l:sub_components = split(l:authority, '@')
    let l:userinfo = l:sub_components[0]
    let l:remaining_authority = l:sub_components[1]
  else
    let l:userinfo = ''
    let l:remaining_authority = l:authority
  endif

  if match(l:remaining_authority, ':') >= 1
    let l:sub_components = split(l:remaining_authority, ':')
    let l:host = l:sub_components[0]
    let l:port = l:sub_components[1]
  else
    let l:host = l:remaining_authority
    let l:port = ''
  endif

  " path
  let l:user_name = l:components[3]
  let l:repository_name = system('git rev-parse --show-toplevel | xargs basename | tr -d "\n"')
  let l:file_path  = system('git rev-parse --show-prefix | tr -d "\n"') . expand('%')

  return {'scheme': l:scheme,
        \ 'userinfo': l:userinfo,
        \ 'host': l:host,
        \ 'port': l:port,
        \ 'user_name': l:user_name,
        \ 'repository_name': l:repository_name,
        \ 'file_path': l:file_path
        \ }
endfunction

" URL Builder
function! GitHubURLBuilder(components)
  let l:path = '/' . a:components['user_name']
           \ . '/' . a:components['repository_name']
           \ . '/' . 'blob'
           \ . '/' . 'master'
           \ . '/' . a:components['file_path']

  return a:components['scheme'] . '://' . a:components['host'] . l:path
endfunction

" URL getter
function! GitHubURL()
  let l:components = GetURLComponents()
  let l:url = GitHubURLBuilder(l:components)
  echo l:url
endfunction
command! GitHubURL call GitHubURL()

" Performance measuring
function! MeasureTime()
  const TRIALS = 1000

  vsplit
  let start_time = reltime()
  for i in range(TRIALS)
    redrawstatus
  endfor
  let stop_time = reltime()
  quit

  let elapsed_time = str2float(reltimestr(stop_time)) - str2float(reltimestr(start_time))
  echom string(elapsed_time) . ' sec / ' . TRIALS . ' times'
  echom string(elapsed_time * 1000) . ' msec / ' . TRIALS . ' times'
  echom string(trunc(elapsed_time * 1000) / TRIALS) . ' msec by time'
endfunction

" Performance measuring
function! ProfileFunc()
  vsplit
  profile start profile.log
  profile func *
  profile file *

  for i in range(1000)
    redrawstatus
    " call feedkeys('i')
    " call feedkeys("\<Esc>")
  endfor

  quit
  profile stop
endfunction
