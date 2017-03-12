if exists('vim_ctags__loaded') | finish | endif | let vim_ctags__loaded = 1
" ###################################################################################################################################################
" ##  Plugin options default values  ################################################################################################################
" ###################################################################################################################################################
if !exists("g:vim_ctags__relative") | let g:vim_ctags__relative = 'always' | endif
if !exists("g:vim_ctags__totals")   | let g:vim_ctags__totals   = 'yes'    | endif
if !exists("g:vim_ctags__jump_behaviors") | let g:vim_ctags__jump_behaviors = { 'before': 'tabnew', 'after': 'norm zvzz' } | endif
if !exists("g:tagbar_ctags_bin") | let uname = system('uname -s') | let osname = ''
  if uname  == "Darwin\n" | let osname = 'mac' | elseif uname == "Linux\n"  | let osname = 'linux'     | endif
  if osname != '' | let g:tagbar_ctags_bin = expand('<sfile>:p:h') .'/../bin/universal-ctags-'. osname | endif
endif

" ###################################################################################################################################################
" ##  Ctags settings  ###############################################################################################################################
" ###################################################################################################################################################
set tags=.tags;/ " Search the nearest 'tags' file in the directory tree

" ###################################################################################################################################################
" ##  Autocommands  #################################################################################################################################
" ###################################################################################################################################################
au BufWritePost * call UpdateFileTags() " Automatically update tags index when a file is saved (and an index exists)

" ###################################################################################################################################################
" ##  Custom functions  #############################################################################################################################
" ###################################################################################################################################################
" Jump to the definition of the tag under the cursor.
function DisplayTag()
  return GoToTag(expand("<cword>"))
endfunction

" Ask you a tag name, then jump to it's definition
function DisplayGivenTag()
  call inputsave() | let s:tag = input('Tag name: ', expand("<cword>")) | call inputrestore() | return GoToTag(s:tag)
endfunction

" Jump to the definition of tagname
function GoToTag(tagname)
  if a:tagname != ""
    try | silent exe "ts ". a:tagname | catch | return | endtry
    exe g:vim_ctags__jump_behaviors['before'] | exe "tjump ". a:tagname | exe g:vim_ctags__jump_behaviors['after']
  endif
endfunction

" (re)Build the list of tags
function RebuildTags()
  let tagfiles = tagfiles()
  if len(tagfiles) == 1 | let tagfile = fnamemodify(get(tagfiles, 0), ':p:h')
    if !filewritable(tagfile) | echohl ErrorMsg | echo '"'. tagfile .'" is not writable!' | echohl None | return | endif
    let tagdir = fnamemodify(tagfile, ': p: h')
  else
    call inputsave() | let tagdir = input('Root directory: ', fnamemodify(getcwd(), ':p:h'), 'dir') | call inputrestore() | echo ' '
    if tagdir == '' | return | endif
  endif
  if !isdirectory(tagdir) || filewritable(tagdir) != 2 | echohl ErrorMsg | echo '"'. tagdir .'" is not writable!' | echohl None | return | endif
  redraw | echohl Search | echo 'Processing tags list update...' | echohl None | echo ExecCtagsCommand(tagdir, tagdir, '-R')
endfunction

" Execute a ctags command
function ExecCtagsCommand(tagdir, source, args)
  let command  = g:tagbar_ctags_bin .' --exclude=.git --exclude=.svn --languages='. &ft .' '
  let command .= exists("g:vim_ctags__args['". &ft ."']")? g:vim_ctags__args[&ft] : ''
  let command .= ' --tag-relative='. g:vim_ctags__relative .' --totals='. g:vim_ctags__totals
  return system(command .' -f '. a:tagdir .'/.tags '. a:args .' '. a:source)
endfunction

" Update the current file tags index
function UpdateFileTags()
  let tagfiles = tagfiles()
  if len(tagfiles) == 1 | let tagfile = get(tagfiles, 0)
    if filewritable(tagfile) | let tagdir = fnamemodify(tagfile, ':p:h')
      if isdirectory(tagdir) && filewritable(tagdir) == 2 | let r = ExecCtagsCommand(tagdir, expand('%:p'), '-a') | endif
    endif
  endif
endfunction

