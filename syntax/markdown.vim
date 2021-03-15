" Vim syntax file
" Language:	Markdown
" Maintainer:	Ben Williams <benw@plasticboy.com>
" URL:		http://plasticboy.com/markdown-vim-mode/
" Remark:	Uses HTML syntax file
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim

  if exists('b:current_syntax')
    unlet b:current_syntax
  endif
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

let s:concealflag = 0
let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 1)
  let s:concealflag = 1
  let s:conceal = ' conceal'
  let s:concealends = ' concealends'
endif
if s:concealflag == 1 && get(g:, 'vim_markdown_conceal_code_blocks', 1)
  let s:concealcode = ' concealends'
endif
if s:concealflag == 1 && get(g:, 'vim_markdown_conceal_links', 0)
  let s:conceallink = ' conceal'
  let s:conceallinkends = ' concealends'
else
  let s:conceallink = ''
  let s:conceallinkends = ''
endif

if &encoding ==# 'utf-8'
    let s:cchars = {
                \'newline': '↵',
                \'image': '▨',
                \'super': 'ⁿ',
                \'sub': 'ₙ',
                \'strike': 'x̶',
                \'atx': '§',
                \'codelang': 'λ',
                \'codeend': '—',
                \'abbrev': '→',
                \'footnote': '†',
                \'definition': ' ',
                \'li': '•',
                \'html_c_s': '‹',
                \'html_c_e': '›'}
else
    " ascii defaults
    let s:cchars = {
                \'newline': ' ',
                \'image': 'i',
                \'super': '^',
                \'sub': '_',
                \'strike': '~',
                \'atx': '#',
                \'codelang': 'l',
                \'codeend': '-',
                \'abbrev': 'a',
                \'footnote': 'f',
                \'definition': ' ',
                \'li': '*',
                \'html_c_s': '+',
                \'html_c_e': '+'}
endif
function! s:ConcealChar(conceal_char)
  if s:concealflag == 1 && get(g:, 'vim_markdown_conceal_chars', 1)
    return ' conceal cchar='.s:cchars[a:conceal_char]
  else
    return ''
  endif
endfunction

" additions to HTML groups
if get(g:, 'vim_markdown_emphasis_multiline', 1)
    let s:oneline = ''
else
    let s:oneline = ' oneline'
endif
execute 'syn region htmlItalic matchgroup=mkdItalic '
    \ . 'start="\%(\s\|_\|^\)\@<=\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\)\@<!\*" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlItalic matchgroup=mkdItalic '
    \ . 'start="\%(\s\|\*\|^\)\@<=_\%(\s\|_\|$\)\@!" end="\%(\s\|_\)\@<!_" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold '
    \ . 'start="\%(\s\|__\|^\)\@<=\*\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\*\)\@<!\*\*" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold '
    \ . 'start="\%(\s\|\*\*\|^\)\@<=__\%(\s\|_\|$\)\@!" end="\%(\s\|__\)\@<!__" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic '
    \ . 'start="\%(\s\|_\|^\)\@<=\*\*\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\)\@<!\*\*\*" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic '
    \ . 'start="\%(\s\|\*\|^\)\@<=___\%(\s\|_\|$\)\@!" end="\%(\s\|_\)\@<!___" '
    \ . 'keepend contains=@Spell' . s:oneline . s:concealends

" Comments
syn region mkdComment start=/<!--\s\=/ end=/\s\=-->/ keepend contains=mkdCommentStart,mkdCommentEnd,@Spell
execute 'syn match mkdCommentStart /<!--/ contained' . s:ConcealChar('html_c_s')
execute 'syn match mkdCommentEnd /-->/ contained' . s:ConcealChar('html_c_e')

" [link](URL) | [link][id] | [link][] | ![image](URL)
syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
execute 'syn region mkdID matchgroup=mkdDelimiter    start="\["    end="\]" contained oneline' . s:conceallink
execute 'syn region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline' . s:conceallink
execute 'syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . s:conceallinkends

" Autolink without angle brackets.
" mkd  inline links:      protocol     optional  user:pass@  sub/domain                    .com, .co.uk, etc         optional port   path/querystring/hash fragment
"                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
syn match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/

" Autolink with parenthesis.
syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"

" Autolink with angle brackets.
syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"

" Link definitions: [id]: URL (Optional Title)
syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"HTML headings
syn region htmlH1 start="^\s*#"      end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn region htmlH2 start="^\s*##"     end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn region htmlH3 start="^\s*###"    end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn region htmlH4 start="^\s*####"   end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn region htmlH5 start="^\s*#####"  end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn region htmlH6 start="^\s*######" end="$" keepend contains=mkdAtx,mkdLink,mkdInlineURL,@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=mkdLink,mkdInlineURL,@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=mkdLink,mkdInlineURL,@Spell
execute 'syn match mkdAtx /#/ contained' . s:ConcealChar('atx')

"define Markdown groups
syn match  mkdLineBreak    /  \+$/
syn region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLink,mkdInlineURL,mkdLineBreak,@Spell
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                     end=/`/'  . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/   end=/``/' . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/  end=/\(\([^\\]\|^\)\\\)\@<!\~\~/'               . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>"                   end="</pre>"'                   . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>"                  end="</code>"'                  . s:concealcode
" TODO: use matchgroup for start and end when working with concealment of
" start/end groups
execute 'syn region mkdCode matchgroup=mkdCodeStart start=/^\s*\z(`\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/ matchgroup=mkdCodeEnd end=/^\s*\z1`*\s*$/' . s:concealcode
execute 'syn region mkdCode start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/ end=/^\s*\z1\~*\s*$/ keepend contains=mkdCodeStart,mkdCodeEnd' . s:concealcode
execute 'syn match  mkdCodeStart    /\(\_^\n\_^\(>\s\)\?\([ ]\{4,}\|\t\)\=\)\@<=\(\~\{3,}\~*\|`\{3,}`*\)/ nextgroup=mkdCodeLang contained' . s:ConcealChar('codelang')
execute 'syn match  mkdCodeEnd      /\(`\{3,}`*\|\~\{3,}\~*\)\(\_$\n\(>\s\)\?\_$\)\@=/ contained' . s:ConcealChar('codeend')
syn match  mkdCodeLang     /\(\s\?\)\@<=.\+\(\_$\)\@=/ contained
syn region mkdFootnote     start="\[^"                     end="\]"
syn match  mkdCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdCode         /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  mkdCode         /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syn match  mkdListItem     /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained
syn region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,@Spell
syn region mkdNonListItemBlock start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syn match  mkdRule         /^\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/
syn match  mkdRule         /^\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/
syn match  mkdRule         /^\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/

" YAML frontmatter
if get(g:, 'vim_markdown_frontmatter', 0)
  syn include @yamlTop syntax/yaml.vim
  syn region Comment matchgroup=mkdDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend
  unlet! b:current_syntax
endif

if get(g:, 'vim_markdown_toml_frontmatter', 0)
  try
    syn include @tomlTop syntax/toml.vim
    syn region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$" transparent contains=@tomlTop keepend
    unlet! b:current_syntax
  catch /E484/
    syn region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$"
  endtry
endif

if get(g:, 'vim_markdown_json_frontmatter', 0)
  try
    syn include @jsonTop syntax/json.vim
    syn region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$" contains=@jsonTop keepend
    unlet! b:current_syntax
  catch /E484/
    syn region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$"
  endtry
endif

if get(g:, 'vim_markdown_math', 0)
  syn include @tex syntax/tex.vim
  syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
  syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend
endif

" Strike through
if get(g:, 'vim_markdown_strikethrough', 0)
    execute 'syn region mkdStrike matchgroup=htmlStrike start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
    HtmlHiLink mkdStrike        htmlStrike
endif

syn cluster mkdNonListItem contains=htmlItalic,htmlBold,htmlBoldItalic,mkdComment,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike

"highlighting for Markdown groups
HtmlHiLink mkdString        String
HtmlHiLink mkdComment       Comment
HtmlHiLink mkdCommentStart  Comment
HtmlHiLink mkdCommentEnd    Comment
HtmlHiLink mkdCode          String
HtmlHiLink mkdCodeDelimiter String
HtmlHiLink mkdCodeStart     String
HtmlHiLink mkdCodeEnd       String
HtmlHiLink mkdCodeLang      Comment
HtmlHiLink mkdFootnote      Comment
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Visual
HtmlHiLink mkdFootnotes     htmlLink
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdInlineURL     htmlLink
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString
HtmlHiLink mkdDelimiter     Delimiter
HtmlHiLink mkdAtx           Statement

let b:current_syntax = "mkd"

delcommand HtmlHiLink
" vim: ts=8
