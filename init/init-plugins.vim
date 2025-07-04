"======================================================================
"
" init-plugins.vim -
"
" Created by skywind on 2018/05/31
" Last Update: 2018/06/10 23:11
" Last modified by Harry.Yue on 2025/05/28
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :



"----------------------------------------------------------------------
" 默认情况下的分组，可以再前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
	"let g:bundle_group += ['tags', 'airline', 'nerdtree', 'ale', 'echodoc', 'terminal']
	let g:bundle_group += ['tags', 'airline', 'nerdtree', 'echodoc', 'terminal']
	let g:bundle_group += ['leaderf', 'keymap']
endif


"----------------------------------------------------------------------
" 将原来配置中的插件导入进来
"----------------------------------------------------------------------
" Bundle 'airblade/vim-gitgutter'
" Bundle 'brookhong/cscope.vim'
" Bundle 'jiangmiao/auto-pairs'
" Bundle 'kien/ctrlp.vim'
" Bundle 'luochen1990/rainbow'
" Plugin 'mileszs/ack.vim'
" Bundle 'msanders/snipmate.vim'
" Bundle 'rib/vimgdb'
" Bundle 'scrooloose/nerdtree'
" Bundle 'scrooloose/nerdcommenter'
" Bundle 'vim-scripts/genutils'
" Bundle 'vim-scripts/lookupfile'
" Bundle 'vim-utils/vim-man'
" Bundle 'vim-scripts/OmniCppComplete'
" Bundle 'vim-scripts/ctags.vim'
" Bundle 'vim-scripts/winmanager'
" Bundle 'yegappan/taglist'
" Bundle 'yegappan/mru'
" " Bundle 'christoomey/vim-run-interactive'
" " Bundle 'croaky/vim-colors-github'
" " Bundle 'danro/rename.vim'
" " Bundle 'kchmck/vim-coffee-script'
" " Bundle 'pbrisbin/vim-mkdir'
" " Bundle 'scrooloose/syntastic'
" " Bundle 'slim-template/vim-slim'
" " Bundle 'thoughtbot/vim-rspec'
" " Bundle 'tpope/vim-bundler'
" " Bundle 'tpope/vim-endwise'
" " Bundle 'tpope/vim-fugitive'
" " Bundle 'tpope/vim-rails'
" " Bundle 'tpope/vim-surround'
" " Bundle 'vim-ruby/vim-ruby'
" " Bundle 'vim-scripts/matchit.zip'
" " Bundle 'vim-scripts/tComment'
" " Bundle 'mattn/emmet-vim'
" " Bundle 'Lokaltog/vim-powerline'
" " Bundle 'godlygeek/tabular'
" " Bundle 'jelera/vim-javascript-syntax'
" " Bundle 'altercation/vim-colors-solarized'
" " Bundle 'othree/html5.vim'
" " Bundle 'xsbeats/vim-blade'
" " Bundle 'Raimondi/delimitMate'
" " Bundle 'groenewege/vim-less'
" " Bundle 'evanmiller/nginx-vim-syntax'
" " Bundle 'Lokaltog/vim-easymotion'
" " Bundle 'tomasr/molokai'

"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" 在 ~/.vim/bundles 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


"----------------------------------------------------------------------
" 默认插件
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'

" 文件浏览器，代替 netrw
Plug 'justinmk/vim-dirvish'

" 表格对齐，使用命令 Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'


"----------------------------------------------------------------------
" Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
" 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
" 比默认的纯按照字母排序更友好点。
"----------------------------------------------------------------------
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	" 取得光标所在行的文本（当前选中的文件名）
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	" 排序文件名
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" 定位到之前光标处的文件
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	" 展示开始画面，显示最近编辑过的文件
	Plug 'mhinz/vim-startify'

	" 一次性安装一大堆 colorscheme
	Plug 'flazz/vim-colorschemes'

	" 支持库，给其他插件用的函数库
	Plug 'xolox/vim-misc'

	" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
	Plug 'kshenoy/vim-signature'

	" 用于在侧边符号栏显示 git/svn 的 diff
	Plug 'mhinz/vim-signify'

	" 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
	" 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
	Plug 'mh21/errormarker.vim'

	" 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
	Plug 't9md/vim-choosewin'

	" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
	Plug 'skywind3000/vim-preview'

	" Git 支持
	Plug 'tpope/vim-fugitive'

	" vim中查看man
	Plug 'vim-utils/vim-man'

	" 括号自动配对
	Plug 'jiangmiao/auto-pairs'

	" 括号不同颜色显示
	Plug 'luochen1990/rainbow'
	let g:rainbow_active = 1
	let g:rainbow_conf = {
				\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
				\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
				\   'operators': '_,_',
				\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
				\   'separately': {
				\       '*': {},
				\   }
				\}

	" 使用 ALT+E 来选择窗口
	nmap <m-e> <Plug>(choosewin)

	" 默认不显示 startify
	let g:startify_disable_at_vimenter = 1
	let g:startify_session_dir = '~/.vim/session'

	" 使用 <space>ha 清除 errormarker 标注的错误
	noremap <silent><space>ha :RemoveErrorMarkers<cr>

	" signify 调优
	let g:signify_vcs_list = ['git', 'svn']
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '~'
	let g:signify_sign_changedelete      = g:signify_sign_change

	" git 仓库使用 histogram 算法进行 diff
	let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	" 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
	Plug 'terryma/vim-expand-region'

	" 快速文件搜索
	Plug 'junegunn/fzf'

	" 给不同语言提供字典补全，插入模式下 c-x c-k 触发
	Plug 'asins/vim-dict'

	" 使用 :FlyGrep 命令进行实时 grep
	Plug 'wsdjeg/FlyGrep.vim'

	" 提供ack插件
	Plug 'mileszs/ack.vim'

	" 使用 :CtrlSF 命令进行模仿 sublime 的 grep
	Plug 'dyng/ctrlsf.vim'

	" 配对括号和引号自动补全
	Plug 'Raimondi/delimitMate'

	" 提供 gist 接口
	Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }

	" ALT_+/- 用于按分隔符扩大缩小 v 选区
	map <m-=> <Plug>(expand_region_expand)
	map <m--> <Plug>(expand_region_shrink)

	" ALT_f 用于开启flygrep的搜索功能
	noremap <silent> <m-f> :FlyGrep<cr>

	" Use ag as ack's search engine
	if executable('ag')
		let g:ackprg = 'ag --vimgrep'
	endif

	" 新增'Todo'与'Debug'命令，用于快速查找特定字符
	command Todo Ack! ' TODO:| FIXME:| HACK:| BUG:| CHANGED:'
	command Debug Ack! ' NOTE:| INFO:| IDEA:'

	" 新增<F8>与<F9>开始调出Todo与Debug标签
	nnoremap <silent> <F8> :Todo<cr>
	nnoremap <silent> <F9> :Debug<cr>
	
	if has('autocmd')
		" 高亮TODO,FIXME, NOTE等字符
		if v:version > 701
			autocmd Syntax * call matchadd('Todo','TODO:\|FIXME:\|HACK:\|BUG:\|CHANGED:)')
			autocmd Syntax * call matchadd('Debug','NOTE:\| INFO:\| IDEA:')
		endif
	endif
endif


"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	" 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'skywind3000/vim-gutentags'

	" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" 默认禁用自动生成
	let g:gutentags_modules = []

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
	"if executable('ctags')
	"	let g:gutentags_modules += ['ctags']
	"endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	"if executable('gtags') && executable('gtags-cscope')
	"	let g:gutentags_modules += ['gtags_cscope']
	"endif

	" 设置 ctags 的参数
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
	" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	let g:gutentags_auto_add_gtags_cscope = 0
endif


"----------------------------------------------------------------------
" 文本对象：textobj 全家桶
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	" 基础插件：提供让用户方便的自定义文本对象的接口
	Plug 'kana/vim-textobj-user'

	" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
	Plug 'kana/vim-textobj-indent'

	" 语法文本对象：iy/ay 基于语法的文本对象
	Plug 'kana/vim-textobj-syntax'

	" 函数文本对象：if/af 支持 c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	" 参数文本对象：i,/a, 包括参数或者列表元素
	Plug 'sgur/vim-textobj-parameter'

	" 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	" 提供 uri/url 的文本对象，iu/au 表示
	Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	" powershell 脚本文件的语法高亮
	Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

	" lua 语法高亮增强
	Plug 'tbastos/vim-lua', { 'for': 'lua' }

	" C++ 语法高亮增强，支持 11/14/17 标准
	Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

	" 额外语法文件
	Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

	" python 语法文件增强
	Plug 'vim-python/python-syntax', { 'for': ['python'] }

	" rust 语法增强
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }

	" dst 文件语法高亮
	"Plug 'goldie-lin/vim-dts', { 'for': 'dts' }
	autocmd BufRead,BufNewFile *.dts,*.dtsi set filetype=dts

	" yocto bitbake文件语法支持
	Plug 'kergoth/vim-bitbake', { 'for': 'bitbake' }
	Plug 'cespare/vim-toml', { 'for': 'bitbake'  }      " 支持 TOML 文件，BitBake 配置文件有时使用 TOML 格式
	Plug 'stevearc/vim-arduino', { 'for': 'bitbake'  }  " 可能包含对 BitBake 的支持，尽管主要是针对 Arduino 的配置文件
	autocmd BufNewFile,BufRead *.bb,*.bbclass set filetype=bitbake

	" vim org-mode
	Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_section_b = '%n'
	let g:airline_theme='deus'
	let g:airline#extensions#branch#enabled = 0
	let g:airline#extensions#syntastic#enabled = 0
	let g:airline#extensions#fugitiveline#enabled = 0
	let g:airline#extensions#csv#enabled = 0
	let g:airline#extensions#vimagit#enabled = 0
endif


"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
	Plug 'Xuyuanp/nerdtree-git-plugin'

	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeHijackNetrw = 0
	let g:NERDTreeWinPos="left"
	let g:NERDTreeWinSize=25
	let g:NERDTreeShowLineNumbers=0
	let g:NERDTreeHidden=1
	let g:NERDTreeQuitOnOpen=1
	" noremap <space>nn :NERDTree<cr>
	" noremap <space>no :NERDTreeFocus<cr>
	" noremap <space>nm :NERDTreeMirror<cr>
	" noremap <space>nt :NERDTreeToggle<cr>
	noremap <silent> <F3> :NERDTreeToggle<cr>
endif


"----------------------------------------------------------------------
" LanguageTool 语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：动态语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	" 设定延迟和提示信息
	let g:ale_completion_delay = 500
	let g:ale_echo_delay = 20
	let g:ale_lint_delay = 500
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'

	" 设定检测的时机：normal 模式文字改变，或者离开 insert模式
	" 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
	let g:ale_lint_on_text_changed = 'normal'
	let g:ale_lint_on_insert_leave = 1

	" 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		let g:ale_command_wrapper = 'nice -n5'
	endif

	" 允许 airline 集成
	let g:airline#extensions#ale#enabled = 1

	" 编辑不同文件类型需要的语法检查器
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'],
				\ 'cpp': ['gcc', 'cppcheck'],
				\ 'python': ['flake8', 'pylint'],
				\ 'lua': ['luac'],
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'],
				\ }


	" 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
	function s:lintcfg(name)
		let conf = s:path('tools/conf/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	" 设置 flake8/pylint 的参数
	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	" 如果没有 gcc 只有 clang 时（FreeBSD）
	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif


"----------------------------------------------------------------------
" echodoc：搭配 YCM/deoplete 在底部显示函数参数
"----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
	Plug 'Shougo/echodoc.vim'
	set noshowmode
	let g:echodoc#enable_at_startup = 1
endif


"----------------------------------------------------------------------
" terminal：在vim中加入terminal，可以不退出vim使用命令行窗口
"----------------------------------------------------------------------
if index(g:bundle_group, 'terminal') >= 0
	" terminal helper 支持
	Plug 'skywind3000/vim-terminal-help'
	let g:terminal_cwd = 2
	let g:terminal_height = 15

	" floating terminal 支持
	" Plug 'voldikss/vim-floaterm'
	" let g:floaterm_keymap_toggle = '<m-->'
	" noremap <m--> :FloatermToggle<cr>
	" tnoremap <silent> <m--> <C-\><C-n>:FloatermToggle<CR>
endif


"----------------------------------------------------------------------
" LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	" 如果 vim 支持 python 则启用  Leaderf
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF'

		" CTRL+p 打开文件模糊匹配
		let g:Lf_ShortcutF = '<c-p>'

		" ALT+n 打开 buffer 模糊匹配
		let g:Lf_ShortcutB = '<m-n>'

		" <F4> 打开最近使用的文件 MRU，进行模糊匹配
		noremap <F4> :LeaderfMru<cr>

		" ALT+p 打开函数列表，按 i 进入模糊匹配，ESC 退出
		noremap <m-p> :LeaderfFunction!<cr>

		" ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
		noremap <m-P> :LeaderfBufTag!<cr>

		" ALT+n 打开 buffer 列表进行模糊匹配
		noremap <m-n> :LeaderfBuffer<cr>

		" ALT+m 全局 tags 模糊匹配
		noremap <m-m> :LeaderfTag<cr>

		" 最大历史文件保存 2048 个
		let g:Lf_MruMaxFiles = 2048

		" ui 定制
		let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		" 如何识别项目目录，从当前文件目录向父目录递归直到碰到下面的文件/目录
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_WindowHeight = 0.30
		let g:Lf_CacheDirectory = expand('~/.vim/cache')

		" 显示绝对路径
		let g:Lf_ShowRelativePath = 0

		" 隐藏帮助
		let g:Lf_HideHelp = 1

		" 模糊匹配忽略扩展名
		let g:Lf_WildIgnore = {
					\ 'dir': ['.svn','.git','.hg'],
					\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
					\ }

		" MRU 文件忽略扩展名
		let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		let g:Lf_StlColorscheme = 'powerline'

		" 禁用 function/buftag 的预览功能，可以手动用 p 预览
		let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

		" 使用 ESC 键可以直接退出 leaderf 的 normal 模式
		let g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }

	else
		" 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		" 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		" 忽略默认键位
		let g:ctrlp_map = ''

		" 模糊匹配忽略
		let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }

		" 项目标志
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		" CTRL+n 打开最近访问过的文件的匹配
		noremap <c-n> :CtrlPMRUFiles<cr>

		" ALT+p 显示当前文件的函数列表
		noremap <m-p> :CtrlPFunky<cr>

		" ALT+n 匹配 buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif


"----------------------------------------------------------------------
" keymap：加入keymap，方便快捷键记忆
"----------------------------------------------------------------------
if index(g:bundle_group, 'keymap') >= 0
	" vim-quickui 支持
	Plug 'skywind3000/vim-quickui'

	" vim-navigateor 支持(for keymaps)
	Plug 'skywind3000/vim-navigator'

	" initialize global keymap and declare prefix key
	let g:navigator = {'prefix':'<tab><tab>'}

	" buffer management
	let g:navigator.b = {
		\ 'name' : '+buffer' ,
		\ '1' : [':b1'        , 'buffer 1'],
		\ '2' : [':b2'        , 'buffer 2'],
		\ '3' : [':b3'        , 'buffer 3'],
		\ '4' : [':b4'        , 'buffer 4'],
		\ '5' : [':b5'        , 'buffer 5'],
		\ '6' : [':b6'        , 'buffer 6'],
		\ 'd' : [':bd'        , 'delete-buffer'],
		\ 'f' : [':bfirst'    , 'first-buffer'],
		\ 'h' : [':Startify'  , 'home-buffer'],
		\ 'l' : [':blast'     , 'last-buffer'],
		\ 'n' : [':bnext'     , 'next-buffer'],
		\ 'p' : [':bprevious' , 'previous-buffer'],
		\ '?' : [':Leaderf buffer' , 'fzf-buffer'],
		\ }

	" tab management
	let g:navigator.t = {
		\ 'name': '+tab',
		\ '1' : ['<key>1gt', 'tab-1'],
		\ '2' : ['<key>2gt', 'tab-2'],
		\ '3' : ['<key>3gt', 'tab-3'],
		\ '4' : ['<key>4gt', 'tab-4'],
		\ '5' : ['<key>5gt', 'tab-5'],
		\ '6' : ['<key>6gt', 'tab-6'],
		\ '7' : ['<key>7gt', 'tab-7'],
		\ '8' : ['<key>8gt', 'tab-8'],
		\ '9' : ['<key>9gt', 'tab-9'],
		\ 'c' : [':tabnew' , 'new-tab'],
		\ 'q' : [':tabclose','close-current-tab'],
		\ 'n' : [':tabnext', 'next-tab'],
		\ 'p' : [':tabprev', 'previous-tab'],
		\ 'o' : [':tabonly', 'close-all-other-tabs'],
		\ }

	" window management
	let g:navigator.w = {
		\ 'name': '+window',
		\ 'p' : [':wincmd p', 'jump-previous-window'],
		\ 'h' : [':wincmd h', 'jump-left-window'],
		\ 'j' : [':wincmd j', 'jump-belowing-window'],
		\ 'k' : [':wincmd k', 'jump-aboving-window'],
		\ 'l' : [':wincmd l', 'jump-right-window'],
		\ 'x' : {
		\		'name': '+management',
		\		'o': ['wincmd o', 'close-other-windows'],
		\	},
		\ }

	" Easymotion
	let g:navigator.m = ['<plug>(easymotion-bd-w)', 'easy-motion-bd-w']
	let g:navigator.n = ['<plug>(easymotion-s)', 'easy-motion-s']

	nnoremap <silent><tab><tab> :Navigator g:navigator<cr>

	" Virtual mode setting
	let g:keymap_visual = {'prefix':'<tab><tab>'}
	let g:keymap_visual['='] = ['<key>=', 'indent-block']
	let g:keymap_visual.q = ['<key>gq', 'format-block']

	vnoremap <silent><tab><tab> :NavigatorVisual *:keymap_visual<cr>
endif


"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()



"----------------------------------------------------------------------
" YouCompleteMe 默认设置：YCM 需要你另外手动编译安装
"----------------------------------------------------------------------

" 禁用预览功能：扰乱视听
let g:ycm_add_preview_to_completeopt = 0

" 禁用诊断功能：我们用前面更好用的 ALE 代替
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone,noselect

" noremap <c-z> <NOP>

" 两个字符自动触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }


"----------------------------------------------------------------------
" Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
"----------------------------------------------------------------------
let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "objc":1,
			\ "objcpp":1,
			\ "python":1,
			\ "java":1,
			\ "javascript":1,
			\ "coffee":1,
			\ "vim":1,
			\ "go":1,
			\ "cs":1,
			\ "lua":1,
			\ "perl":1,
			\ "perl6":1,
			\ "php":1,
			\ "ruby":1,
			\ "rust":1,
			\ "erlang":1,
			\ "asm":1,
			\ "nasm":1,
			\ "masm":1,
			\ "tasm":1,
			\ "asm68k":1,
			\ "asmh8300":1,
			\ "asciidoc":1,
			\ "basic":1,
			\ "vb":1,
			\ "make":1,
			\ "cmake":1,
			\ "html":1,
			\ "css":1,
			\ "less":1,
			\ "json":1,
			\ "cson":1,
			\ "typedscript":1,
			\ "haskell":1,
			\ "lhaskell":1,
			\ "lisp":1,
			\ "scheme":1,
			\ "sdl":1,
			\ "sh":1,
			\ "zsh":1,
			\ "bash":1,
			\ "man":1,
			\ "markdown":1,
			\ "matlab":1,
			\ "maxima":1,
			\ "dosini":1,
			\ "conf":1,
			\ "config":1,
			\ "zimbu":1,
			\ "ps1":1,
			\ }

