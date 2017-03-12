# vim-ctags
Simple [VIm](http://www.vim.org/) plugin to manage ctags index.

## Usage / Details
* Before tag jump is available, you have to build the tag index
* When a file is saved, the tags index is quickly updated automaticaly (if an index exists)
* If you have modified something outside of VIm (update your libraries / framework for example), you have to rebuild the index
* If you want to remove the index file, simply remove the `.tags` file, this plugin doesn't generate other files

### Available functions
* **RebuildTags()**: (re)Build the list of tags
* **ExecCtagsCommand(tagdir, source, args)**: Execute a ctags command
* **GoToTag(tagname)**: Jump to the definition of `tagname`
* **DisplayTag()**: Jump to the definition of the tag under the cursor.
* **DisplayGivenTag()**: Ask you a tag name, then jump to it's definition
* **UpdateFileTags()**: Update the current file tags index

By default, this plugin doesn't provide keyboard shortcuts, and do nothing by itself. You have to manually call the functions or map a key to do it (see [configuration section](#configuration)).

#### RebuildTags
When used the first time, a prompt will ask you the root path of your project (prefilled with the current file location). Once validated, the index is generating, this can take time depending of the number of files to parse (for example, about 5 seconds for a [Drupal 8 project](https://www.drupal.org/8) on my Mac, and less than 10 in [my VM](https://github.com/webastien/dev-vm)). Then, if you need to rebuild it, the path is now guessed automaticaly and no more asked. Note that the index is maintained updated each time you save a file (in VIm), it's much quicker than a full rebuild, don't worry.

#### ExecCtagsCommand
Take 3 arguments:
* **tagdir**: Path to the directory containing the ctags index file
* **source**: Path to the directory from which to perform the ctags command
* **args**: Arguments to pass to ctags command

#### GoToTag / DisplayTag / DisplayGivenTag / ...
* If you don't want to use a keyboard mapping for it, you can simply call them in the VIm command line: `:call GoToTag('myfunction'')` for example.
* If there is more than one definition corresponding to this tag, VIm will offer you the choice in a preview window (`:h ts` for more details).
* By default, the definition is opened in a new tab. To change this behavior, see [configuration section](#configuration).

## Configuration
### Ctags binary path
If you have ctags installed by a classic method, you should have nothing to do on Linux and Mac: The path of the available ctags binary is guessed. You can execute `:echo g:tagbar_ctags_bin` in VIm to check if the choosen version is correct. If not, or if you want to use custom binary, you just have to put its path in the variable `g:tagbar_ctags_bin`. Example:

```
let g:tagbar_ctags_bin='/usr/local/bin/my-custom-ctags-binary'
```

**Note:** You may recognize this variable as part of [tagbar plugin](http://majutsushi.github.com/tagbar/), and it's right. I choose to reuse this one because I'm using it too and it also requires ctags, so like that the both plugins are configured in the same time.

### Ctags arguments
Arguments to pass to ctags, in a dict variable: Keys are language, values are relative arguments. More infos: [Sourceforge ctags documentation](http://ctags.sourceforge.net/ctags.html), [Universal Ctags](http://docs.ctags.io/en/latest/news.html#new-and-extended-options). Example:

```
let g:vim_ctags__args = {
    'php': '--langmap=php:.php.inc.module.theme.install.engine.profile.view --php-kinds=cdfi --fields=+aimlS'
  \}
```

**Note:** Some arguments are already added directly:
* `-R` (recursive) Used for build / rebuild the index
* `-a` (append) Used when saving a single file
* `-f` (tags index file) Gives to ctags the path to the index file
* `--languages` (language name) Auto-populated with the current file filetype
* `--exclude=.git --exclude=.svn` (exclude subversion and git directories) Always added
* `--tag-relative` (tag path relative to tags index file) see below
* `--totals` (display a reporting after rebuild) see below

The last 2 arguments can be customized with the following options. The value presented here is the default one.

```
let g:vim_ctags__relative = 'always'  " yes / no, and also always / never with universal-ctags
let g:vim_ctags__totals   = 'yes'     " yes / no
```

### Tag jump behavior
You can change the default behaviors of tag jump: Open a new tab before and open needed folds after.
```
let g:vim_ctags__jump_behaviors = { 'before': 'tabnew', 'after': 'norm zvzz' }
```

### Keyboard mapping
Here is the keyboad mapping I use in my [VIM tweaks](https://github.com/webastien/vim-tweaks) plugin, you can copy this to your `.vimrc` file, and personalize to fit your linking.
```
map      <silent> <F3> :call DisplayTag()<CR>
map      <silent> <F4> :call DisplayGivenTag()<CR>
nnoremap <silent> <F5> :call RebuildTags()<CR>
```

## About ctags
[Ctags](https://en.wikipedia.org/wiki/Ctags) is a tool to build an index of classes, functions, ... You can use to jump to their definitions, auto-complete when typing, ... VIm has native support and a lot of plugins to play with it (you can see how I integrate it in [my VIm config](https://github.com/webastien/vim)). Firstly, I used [Exuberant Ctags](http://ctags.sourceforge.net), but finaly move to [Universal Ctags](https://ctags.io) which is more recent.

## Installation
### The VIm plugin
Install this plugin like any other, by copying its file to your `.vim` directory (old school), or with your favorite plugins manager. For example, with [Vundle](http://github.com/gmarik/vundle), you just have to add `Plugin 'webastien/vim-ctags'` to your `.vimrc` file, and run `:PluginInstall`.

### Ctags utility
#### The easy way... (Universal Ctags, Linux / Mac)
This plugin embed a compiled binary of [Universal Ctags](https://ctags.io) for Linux and Mac, in the [bin directory](https://github.com/webastien/vim-ctags/tree/master/.vim/bin), so you can use the one you need directly without compile it yourself (see [configuration section](#configuration)).

#### Classic method
**Refer to the documentation of the `ctags` utility you choose**: It can be [excuberant ctags](http://ctags.sourceforge.net), [Universal Ctags](http://ctags.io), and probably [other derivates](https://en.wikipedia.org/wiki/Ctags#Variants_of_ctags) (I haven't tried others). (Note that the MacOS pre-installed one is old and may not gives you the better experience.)

##### Exuberant ctags
I'm pretty sure all Linux distributions provide a package for [excuberant ctags](http://ctags.sourceforge.net). For example, on [Debian](https://www.debian.org) and derivates ([Ubuntu](https://www.ubuntu.com), [Linux Mint](https://linuxmint.com), ...) `sudo apt install ctags` is enought. Otherwise, download it from [Sourceforge](http://ctags.sourceforge.net).

##### Universal ctags
You have to build, configure and compile. Refer to the [official documentation](http://docs.ctags.io/en/latest/building.html).

