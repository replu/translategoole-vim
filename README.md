translategoogle-vim.vim
===================

Translate text using Google Translate.


## Requirement

[translate-shell](http://www.soimort.org/translate-shell/)

[vimproc](https://github.com/Shougo/vimproc.vim)


## Usage

```
:GoogleTransEJ
```

Translate the current line from Englesh to Japanese

```
:'<,'>GoogleTransEJ
```

Translate the selected block from Englesh to Japanese

```
:GoogleTransJE
```

Translate the current line from Japanese to English

```
:'<,'>GoogleTransJE
```

Translate the selected block from Japanese to English

##Install

```
NeoBundle 'git@github.com:replicity/translategoole-vim.git', {
			\ 'depends' : "Shougo/vimproc"
			\}
```

## Author

replicity



