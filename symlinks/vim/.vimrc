autocmd!

"-------------------------------------------------------------------------------
" Plugins
"-------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'scrooloose/nerdcommenter'
    Plug 'Yggdroot/indentLine'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'kien/ctrlp.vim'
    Plug '/scrooloose/syntastic'
    Plug 'osyo-manga/vim-over'
    " Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
    Plug 'ervandew/supertab'

    Plug 'chriskempson/vim-tomorrow-theme'

call plug#end()

"-------------------------------------------------------------------------------
" Key maps
"-------------------------------------------------------------------------------

nnoremap <silent><Esc><Esc> :nohlsearch<CR> " <Esc>2回押しでハイライトを消去
nnoremap <silent><C-s> :NERDTreeToggle<CR>
nnoremap <silent><Space>/ :NERDCommenterToggle<CR>

" vim(rc)
nnoremap <Space>r :<C-u>execute "source " expand("%:p")<CR>
nnoremap <Space>, :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>. :<C-u>edit $MYGVIMRC<CR>

"-------------------------------------------------------------------------------
" Settings
"-------------------------------------------------------------------------------

set autoindent smartindent                         " インデントをいい感じにする
set autoread                                       " 外部エディタで編集中のファイルが変更されたら、自動的に読み直す
set backspace=indent,eol,start                     " バックスペースでなんでも消せるようにする
set clipboard=unnamed,autoselect                   " ヤンクをクリップボードに送る
set confirm                                        " ファイルを保存していない場合は確認
set cursorline                                     " カーソルがある行を強調表示する
set expandtab                                      " <Tab>で空白文字を使う
set hidden                                         " 編集中でも他のファイルを開けるようにする
set history=1000                                   " コマンド履歴いっぱい
set hlsearch                                       " 検索結果をハイライト
set ignorecase smartcase                           " 検索で大文字を含む場合のみ大文字/小文字を区別する
set incsearch                                      " インクリメンタルサーチ
set keymodel=startsel,stopsel                      " Shift+矢印キーで選択
set list                                           " 空白文字とか視えないやつを表示
set listchars=tab:▸\ ,trail:.,extends:»,precedes:« " listで表示される文字のフォーマット
set mouse=a                                        " マウス操作を有効にする
set nobackup                                       " バックアップファイルいらない
set nocompatible                                   " Vi互換を無効にする
set nomodeline                                     " モードラインの無効化
set noswapfile                                     " スワップファイルいらない
set nowrap                                         " 長い行を折り返さない
set number                                         " 行番号を表示する
set ruler                                          " カーソルが何行目の何列目に置かれているかを表示する
set scrolloff=5                                    " スクロール時の余白
set shiftwidth=4                                   " インデントは空白文字4つ
set showmatch                                      " 閉じ括弧が入力されたとき、対応する括弧を表示する
set sidescrolloff=5                                " スクロール時の余白
set softtabstop=4                                  " インデントは空白文字4つ
set tabstop=4                                      " インデントは空白文字4つ
set title                                          " ファイル名を表示
set ttyfast                                        " スクロールを滑らかにする
set ttymouse=xterm2                                " ターミナルでxterm風にマウスを扱う
set whichwrap+=h,l,<,>,[,]                         " カーソルを行頭、行末で止まらないようにする
set wildmenu                                       " 補完候補を表示する
set wrapscan                                       " 最後まで検索が終わったら先頭に戻る

" Remove unwanted spaces
autocmd BufWritePre *.pl :%s/\s\+$//e
