# vim-ctags: Embeded binary files

## Ctags executables (universal-ctags aka ctags.io)

* **Official website:** https://ctags.io
* **Github repository:** https://github.com/universal-ctags/ctags
* **Documentation:** http://docs.ctags.io/en/latest/index.html
* **Main authors:** http://docs.ctags.io/en/latest/developers.html
* **Contributors:** https://github.com/universal-ctags/ctags/graphs/contributors
* **Licence:** https://github.com/universal-ctags/ctags/blob/master/COPYING

I've generated the Linux and Mac versions following the official methods (details below). I didn't make any changes in them before (and after). I've simply extract the generated binary to put it here, and to not have do it again each time I install another machine. I don't know if and when I will update them, so if you want fresh versions, you have to compile them by yourself.

### universal-ctags-linux
Manual compilation as [described here](http://docs.ctags.io/en/latest/autotools.html).
I did it with my [developement virtual machine](https://github.com/webastien/dev-vm), running Debian 8.

```
universal-ctags-linux --version

Universal Ctags 0.0.0(b6841a1), Copyright (C) 2015 Universal Ctags Team
Universal Ctags is derived from Exuberant Ctags.
Exuberant Ctags 5.8, Copyright (C) 1996-2009 Darren Hiebert
  Compiled: Mar  4 2017, 23:21:47
  URL: https://ctags.io/
  Optional compiled features: +wildcards, +regex, +option-directory, +coproc
```

### universal-ctags-mac
Brew installation as [explained here](http://docs.ctags.io/en/latest/osx.html#building-with-homebrew).
I did it with an OsX virtual machine (on a Mac host), running Mac OS 10.12.3.

```
universal-ctags-mac --version

Universal Ctags 0.0.0(16eccf0), Copyright (C) 2015 Universal Ctags Team
Universal Ctags is derived from Exuberant Ctags.
Exuberant Ctags 5.8, Copyright (C) 1996-2009 Darren Hiebert
  Compiled: Mar 12 2017, 17:15:24
  URL: https://ctags.io/
  Optional compiled features: +wildcards, +regex, +option-directory, +coproc, +xpath, +case-insensitive-filenames
```

