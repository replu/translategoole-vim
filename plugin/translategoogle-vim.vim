" http://d.hatena.ne.jp/osyo-manga/touch/20121009/1349765140
set updatetime=100

augroup vimproc-async-receive-test
augroup END

" コマンド終了時に呼ばれる関数
function! s:finish(result)
	let bufname = '==Translate== Google'

	"バッファ作成
	let winnr = bufwinnr(bufname)
	if winnr < 1
		execute 'below new'.escape(bufname, ' ')
	else
		if winnr != winnr()
			"w番目のウィンドウに移動
			execute winnr.'wincmd w'
		endif
	endif

	setlocal buftype=nofile bufhidden=hide noswapfile wrap ft=
	"バッファをクリア
    silent % delete _
	call setline(1, split(a:result, "\n"))
	normal sk
endfunction

function! s:receive_vimproc_result()
    if !has_key(s:, "vimproc")
        return
    endif

    let vimproc = s:vimproc

    try
        if !vimproc.stdout.eof
            let s:result .= vimproc.stdout.read()
        endif

        if !vimproc.stderr.eof
            let s:result .= vimproc.stderr.read()
        endif

        if !(vimproc.stdout.eof && vimproc.stderr.eof)
            return 0
        endif
    catch
        echom v:throwpoint
    endtry

    " 終了時に呼ぶ
    call s:finish(s:result)
    
    augroup vimproc-async-receive-test
        autocmd!
    augroup END

    call vimproc.stdout.close()
    call vimproc.stderr.close()
    call vimproc.waitpid()
    unlet s:vimproc
    unlet s:result
endfunction

function! s:system_async(cmd)
    let cmd = a:cmd
    " let vimproc = vimproc#pgroup_open(cmd)
    let vimproc = vimproc#popen3(cmd)
    call vimproc.stdin.close()
    
    let s:vimproc = vimproc
    let s:result = ""
    
    augroup vimproc-async-receive-test
        execute "autocmd! CursorHold,CursorHoldI * call"
\               "s:receive_vimproc_result()"
    augroup END
endfunction

function! TranslateGoogleEJ() range
	let curline = a:firstline
	let strline = ''
	while curline <= a:lastline
		let tmpline = substitute(getline(curline), '^\s\+\|\s\+$', '', 'g')
		if tmpline=~ '\m^\a' && strline =~ '\m\a$'
			let strline = strline .' '. tmpline
		else
			let strline = strline . tmpline
		endif
		let curline = curline + 1
		"改行
		let strline = strline . "\n"
	endwhile
	call s:system_async("trans -no-ansi {en=ja} \"".strline."\"")
endfunction

function! TranslateGoogleJE() range
	let curline = a:firstline
	let strline = ''
	while curline <= a:lastline
		let tmpline = substitute(getline(curline), '^\s\+\|\s\+$', '', 'g')
		if tmpline=~ '\m^\a' && strline =~ '\m\a$'
			let strline = strline .' '. tmpline
		else
			let strline = strline . tmpline
		endif
		let curline = curline + 1
		"改行
		let strline = strline . "\n"
	endwhile
	call s:system_async("trans -no-ansi {ja=en} \"".strline."\"")
endfunction

command! -nargs=0 -range TranslateGoogleEJ <line1>,<line2>call TranslateGoogleEJ()
command! -nargs=0 -range TranslateGoogleJE <line1>,<line2>call TranslateGoogleJE()
