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
function! BitbucketURLBuilder(components)
  let l:path = '/' . 'projects'
           \ . '/' . toupper(a:components['user_name'])
           \ . '/' . 'repos'
           \ . '/' . a:components['repository_name']
           \ . '/' . 'browse'
           \ . '/' . a:components['file_path']

  return a:components['scheme'] . '://' . a:components['host'] . l:path
endfunction

function! GitHubURLBuilder(components)
  let l:path = '/' . a:components['user_name']
           \ . '/' . a:components['repository_name']
           \ . '/' . 'blob'
           \ . '/' . 'master'
           \ . '/' . a:components['file_path']

  return a:components['scheme'] . '://' . a:components['host'] . l:path
endfunction

" URL getter
function! BitbucketURL()
  let l:components = GetURLComponents()
  let l:url = BitbucketURLBuilder(l:components)
  echo l:url
endfunction
command! BitbucketURL call BitbucketURL()

function! GitHubURL()
  let l:components = GetURLComponents()
  let l:url = GitHubURLBuilder(l:components);
  echo l:url
endfunction
command! GitHubURL call GitHubURL()
