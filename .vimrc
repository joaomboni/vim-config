" ============================================================================
" 1. CONFIGURAÇÕES BÁSICAS
" ============================================================================
" ==== BASE ====
set encoding=utf-8
scriptencoding utf-8
set termguicolors

let mapleader = " "
set number
set termguicolors
set mouse=a
set clipboard=unnamedplus
set cursorline
set wrap

" ==== IDENTAÇÃO/ARQUIVOS
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
filetype plugin indent on

" ==== BUSCA ====
set ignorecase smartcase
set incsearch
set hlsearch

" ==== OUTROS ====
set undofile
" set clipboard=unnamedplus

" Sugestão: removi 'preview' para o menu não abrir uma janela extra no topo
set completeopt=menu,menuone,noselect

" ============================================================================
" 2. GERENCIADOR DE PLUGINS
" ============================================================================
call plug#begin('~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'dense-analysis/ale'
  Plug 'vim-scripts/AutoComplPop'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ycm-core/YouCompleteMe'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'ervandew/supertab'
call plug#end()

" ============================================================================
" 3. MAPEAMENTOS
" ============================================================================
nnoremap <leader>e :NERDTreeToggle<CR>

" Ctrl + p: Alterna o cursor entre Árvore e Editor
nnoremap <C-p> <C-w>w

" Salva, Compila e Roda C
autocmd FileType c nnoremap <buffer> <leader>r :w<CR>:!gcc % -o %< && ./%<<CR>

" ============================================================================
" 4. AUTO-SUGESTÃO (C/C++)
" ============================================================================
set omnifunc=ccomplete#Complete
let g:acp_enableAtStartup = 1
let g:acp_behaviorKeywordLength = 2

" ============================================================================
" 5. CONFIGURAÇÃO ALE (Linter)
" ============================================================================
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
let g:ale_linters = { 'asciidoc': ['vale'] }
let g:ale_fix_on_save = 1
" Deixe o autocomplete para o AutoComplPop, evite conflitos:
let g:ale_completion_enabled = 0

" ============================================================================
" 6. FUNÇÕES ADAPTADAS (ADOC/MAN)
" ============================================================================
if has("autocmd")
  au BufNewFile,BufRead *.adoc call Set_ADOC()
  au BufNewFile,BufRead *.[1-9] call Set_MAN()
endif

function! ShowSpecial()
  setlocal list listchars=tab:>>,trail:*,eol:$
  hi def link nontext ErrorMsg
endfunction

function! Set_COMMON()
  setlocal number shiftwidth=2 tabstop=8 softtabstop=2 autoindent smartindent
  call ShowSpecial()
endfunction

function! Set_ADOC()
  setlocal syntax=asciidoc filetype=asciidoc
  call Set_COMMON()
endfunction

function! Set_MAN()
  setlocal syntax=man filetype=man textwidth=70
  noremap <buffer> P gqj
  noremap <buffer> T :s/        /\t/<CR>
  call Set_COMMON()
endfunction

" ============================================================================
" 7. CONFIGURAÇÃO DA STATUSLINE (AIRLINE)
" ============================================================================
"let g:airline_theme='desert'
let g:airline_powerline_fonts = 1
let g:airline_detect_spell=0 "

" Configuração dos símbolos internos (Branch, Cadeado, Pinguim)
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Definição dos separadores de borda
let g:airline_left_sep      = ''
let g:airline_left_alt_sep  = ''
let g:airline_right_sep     = ''
let g:airline_right_alt_sep = ''


let g:airline_symbols.branch     = ''
let g:airline_symbols.readonly   = ''
let g:airline_symbols.linenr     = '☰ '
let g:airline_symbols.maxlinenr  = '  '
let g:airline_symbols.dirty      = '⚡'

" Sua seção customizada com o Pinguim e o Tipo de Arquivo
let g:airline_section_z = '%l/%L : %c 🐧 Linux [%Y]'


" 8. --- Configurações do YouCompleteMe ---
" Define o arquivo de configuração global
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" Carrega configurações extras automaticamente sem perguntar
let g:ycm_confirm_extra_conf = 0

" Atalho para ir na definição (funciona para PHP e C)
" Uso: \ + j + d
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" 9.  ===== SERVIDOR DE LINGUAGEM CCLS ======
let g:ycm_language_server =
  \ [{
  \   'name': 'ccls',
  \   'cmdline': [ 'ccls' ],
  \   'filetypes': [ 'c', 'cpp', 'cc', 'h', 'hpp', 'objc', 'objcpp' ],
  \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
  \ }]

" 10. ======= UTILSNIPS =====
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" ============================================================================
" 11. ESTÉTICA FINAL
" ============================================================================
" Fecha o Vim se sobrar apenas o NERDTree aberto
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

syntax on
" colorscheme desert
set laststatus=2
