" SPDX-FileCopyrightText: © 2022 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Benjamin D. Williams <benw@plasticboy.com>
" SPDX-License-Identifier: MIT

scriptencoding utf-8

" Read the HTML syntax to start with
if v:version < 600
  source <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim

  if exists('b:current_syntax')
    unlet b:current_syntax
  endif
endif

if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" don't use standard HiLink, it will not work with included syntax files
if v:version < 508
  command! -nargs=+ HtmlHiLink highlight link <args>
else
  command! -nargs=+ HtmlHiLink highlight default link <args>
endif

syntax spell toplevel
syntax case ignore
syntax sync linebreaks=1

let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 1)
  let s:conceal = ' conceal'
  let s:concealends = ' concealends'
endif
if has('conceal') && get(g:, 'vim_markdown_conceal_code_blocks', 1)
  let s:concealcode = ' concealends'
endif

" additions to HTML groups
if get(g:, 'vim_markdown_emphasis_multiline', 1)
    let s:oneline = ''
else
    let s:oneline = ' oneline'
endif
syntax region mkdItalic matchgroup=mkdItalic start="\%(\*\|_\)"    end="\%(\*\|_\)"
syntax region mkdBold matchgroup=mkdBold start="\%(\*\*\|__\)"    end="\%(\*\*\|__\)"
syntax region mkdBoldItalic matchgroup=mkdBoldItalic start="\%(\*\*\*\|___\)"    end="\%(\*\*\*\|___\)"
execute 'syntax region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs\*\ze[^\\\*\t ]\%(\%([^*]\|\\\*\|\n\)*[^\\\*\t ]\)\?\*\_W" end="[^\\\*\t ]\zs\*\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syntax region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs_\ze[^\\_\t ]" end="[^\\_\t ]\zs_\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syntax region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs\*\*\ze\S" end="\S\zs\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syntax region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs__\ze\S" end="\S\zs__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syntax region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs\*\*\*\ze\S" end="\S\zs\*\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syntax region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs___\ze\S" end="\S\zs___" keepend contains=@Spell' . s:oneline . s:concealends

" [link](URL) | [link][id] | [link][] | ![image](URL)
syntax region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
execute 'syntax region mkdID matchgroup=mkdDelimiter    start="\["    end="\]" contained oneline' . s:conceal
execute 'syntax region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline' . s:conceal
execute 'syntax region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . s:concealends

" Autolink without angle brackets.
" mkd  inline links:      protocol     optional  user:pass@  sub/domain                    .com, .co.uk, etc         optional port   path/querystring/hash fragment
"                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
syntax match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/

" Autolink with parenthesis.
syntax region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"

" Autolink with angle brackets.
syntax region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"

" Link definitions: [id]: URL (Optional Title)
syntax region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syntax region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"HTML headings
syntax region htmlH1       matchgroup=mkdHeading     start="^\s*#"                   end="$" contains=@mkdHeadingContent,@Spell
syntax region htmlH2       matchgroup=mkdHeading     start="^\s*##"                  end="$" contains=@mkdHeadingContent,@Spell
syntax region htmlH3       matchgroup=mkdHeading     start="^\s*###"                 end="$" contains=@mkdHeadingContent,@Spell
syntax region htmlH4       matchgroup=mkdHeading     start="^\s*####"                end="$" contains=@mkdHeadingContent,@Spell
syntax region htmlH5       matchgroup=mkdHeading     start="^\s*#####"               end="$" contains=@mkdHeadingContent,@Spell
syntax region htmlH6       matchgroup=mkdHeading     start="^\s*######"              end="$" contains=@mkdHeadingContent,@Spell
syntax match  htmlH1       /^.\+\n=\+$/ contains=@mkdHeadingContent,@Spell
syntax match  htmlH2       /^.\+\n-\+$/ contains=@mkdHeadingContent,@Spell

"define Markdown groups
syntax match  mkdLineBreak    /  \+$/
syntax region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLink,mkdInlineURL,mkdLineBreak,@Spell
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                     end=/`/'  . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/   end=/``/' . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/                       end=/^\s*\z1`*\s*$/'            . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/  end=/\(\([^\\]\|^\)\\\)\@<!\~\~/'               . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/      end=/^\s*\z1\~*\s*$/'           . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>"                   end="</pre>"'                   . s:concealcode
execute 'syntax region mkdCode matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>"                  end="</code>"'                  . s:concealcode
syntax region mkdFootnote     start="\[^"                     end="\]"
syntax match  mkdCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syntax match  mkdCode         /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syntax match  mkdCode         /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syntax match  mkdListItem     /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained nextgroup=mkdListItemCheckbox
syntax match  mkdListItemCheckbox     /\[[xXoO ]\]\ze\s\+/ contained contains=mkdListItem
syntax region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,mkdListItemCheckbox,@Spell
syntax region mkdNonListItemBlock start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syntax match  mkdRule         /^\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/
syntax match  mkdRule         /^\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/
syntax match  mkdRule         /^\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/

" YAML frontmatter
if get(g:, 'vim_markdown_frontmatter', 0)
  syntax include @yamlTop syntax/yaml.vim
  syntax region Comment matchgroup=mkdDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend
  unlet! b:current_syntax
endif

if get(g:, 'vim_markdown_toml_frontmatter', 0)
  try
    syntax include @tomlTop syntax/toml.vim
    syntax region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$" transparent contains=@tomlTop keepend
    unlet! b:current_syntax
  catch /E484/
    syntax region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$"
  endtry
endif

if get(g:, 'vim_markdown_json_frontmatter', 0)
  try
    syntax include @jsonTop syntax/json.vim
    syntax region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$" contains=@jsonTop keepend
    unlet! b:current_syntax
  catch /E484/
    syntax region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$"
  endtry
endif

if get(g:, 'vim_markdown_math', 0)
  syntax include @tex syntax/tex.vim
  syntax region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
  syntax region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend
endif

" Strike through
if get(g:, 'vim_markdown_strikethrough', 0)
    execute 'syntax region mkdStrike matchgroup=htmlStrike start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
    HtmlHiLink mkdStrike        htmlStrike
endif

syntax cluster mkdHeadingContent contains=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdLink,mkdInlineURL,mkdStrike,mkdCode
syntax cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike

"highlighting for Markdown groups
HtmlHiLink mkdString           String
HtmlHiLink mkdCode             String
HtmlHiLink mkdCodeDelimiter    String
HtmlHiLink mkdCodeStart        String
HtmlHiLink mkdCodeEnd          String
HtmlHiLink mkdFootnote         Comment
HtmlHiLink mkdBlockquote       Comment
HtmlHiLink mkdListItem         Identifier
HtmlHiLink mkdListItemCheckbox Identifier
HtmlHiLink mkdRule             Identifier
HtmlHiLink mkdLineBreak        Visual
HtmlHiLink mkdFootnotes        htmlLink
HtmlHiLink mkdLink             htmlLink
HtmlHiLink mkdURL              htmlString
HtmlHiLink mkdInlineURL        htmlLink
HtmlHiLink mkdID               Identifier
HtmlHiLink mkdLinkDef          mkdID
HtmlHiLink mkdLinkDefTarget    mkdURL
HtmlHiLink mkdLinkTitle        htmlString
HtmlHiLink mkdDelimiter        Delimiter

let b:current_syntax = 'mkd'

delcommand HtmlHiLink
