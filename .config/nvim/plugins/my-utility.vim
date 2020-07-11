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

function! BitbucketUrl()
  let l:components = GetURLComponents()
  let l:path = '/' . 'projects'
           \ . '/' . toupper(l:components['user_name'])
           \ . '/' . 'repos'
           \ . '/' . l:components['repository_name']
           \ . '/' . 'browse'
           \ . '/' . l:components['file_path']

  echo l:components['scheme'] . '://' . l:components['host'] . l:path
endfunction
command! BitbucketUrl call BitbucketUrl()

function! GitHubUrl()
  let l:components = GetURLComponents()
  let l:path = '/' . l:components['user_name']
           \ . '/' . l:components['repository_name']
           \ . '/' . 'blob'
           \ . '/' . 'master'
           \ . '/' . l:components['file_path']

  echo l:components['scheme'] . '://' . l:components['host'] . l:path
endfunction
command! GitHubUrl call GitHubUrl()
