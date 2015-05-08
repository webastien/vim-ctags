if !exists("g:tagbar_ctags_bin")
    let g:tagbar_ctags_bin = substitute(system('which ctags'), "\n", '', '')
endif

function DisplayTag()
  let s:tag = expand("<cword>")

  if s:tag != ""
    try
      silent exe "ts ". s:tag
    catch
      return
    endtry

    exe "tabnew" | exe "tag ". s:tag | exe "norm zvzz"
  endif
endfunction

function RebuildTags()
  let tagfiles = tagfiles()

  if len(tagfiles) == 1
    let tagfile = get(tagfiles, 0)

    if !filewritable(tagfile)
      echohl ErrorMsg | echo '"'. tagfile .'" is not writable!' | echohl None
      return
    endif

    let tagdir = fnamemodify(tagfile, ':p:h')
  else
    call inputsave() | let tagdir = input('Root directory: ', fnamemodify(getcwd(), ':p'), 'dir') | call inputrestore()

    if tagdir == ''
      return
    endif
  endif

  if !isdirectory(tagdir) || filewritable(tagdir) != 2
    echohl ErrorMsg | echo '"'. tagdir .'" is not writable!' | echohl None
    return
  endif

  echo 'Processing tags list update...'
  echo ExecCtagsCommand(tagdir, tagdir, '--recurse')
endfunction

function ExecCtagsCommand(tagdir, source, args)
  let command  = g:tagbar_ctags_bin  .' --langmap=php:.php.inc.module.install.view.engine.theme --php-kinds=cdfi --languages=php'
  let command .= ' --tag-relative=yes --totals=yes -f '. a:tagdir .'/.tags '. a:args .' '. a:source

  return system(command)
endfunction

function UpdateTags()
  let tagfiles = tagfiles()

  if len(tagfiles) == 1
    let tagfile = get(tagfiles, 0)

    if filewritable(tagfile)
      let tagdir = fnamemodify(tagfile, ':p:h')

      if isdirectory(tagdir) && filewritable(tagdir) == 2
        let result = ExecCtagsCommand(tagdir, expand('%:p'), '-a')
      endif
    endif
  endif
endfunction

" Exuberant-ctags settings (Search the nearest 'tags' file in the directory tree)
set tags=.tags;/
" Automatically update tags of a saved file
autocmd BufWritePost *.php,*.inc,*.module,*.install,*.view,*.engine,*.theme call UpdateTags()

