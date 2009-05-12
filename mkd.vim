" Vim syntax file
" Language:	Markdown
" Maintainer:	Ben Williams <benw@plasticboy.com>
" URL:		http://plasticboy.com/markdown-vim-mode/
" Version:	8
" Last Change:  2008 April 29 
" Remark:	Uses HTML syntax file
" Remark:	I don't do anything with angle brackets (<>) because that would too easily
"		easily conflict with HTML syntax
" TODO: 	Do something appropriate with image syntax
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
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

"additions to HTML groups
syn region htmlBold     start=/\(^\|\s\)\*\@<!\*\*\*\@!/     end=/\*\@<!\*\*\*\@!\($\|\s\)/   contains=@Spell,htmlItalic
syn region htmlItalic   start=/\(^\|\s\)\*\@<!\*\*\@!/       end=/\*\@<!\*\*\@!\($\|\s\)/      contains=htmlBold,@Spell
syn region htmlBold     start=/\(^\|\s\)_\@<!___\@!/         end=/_\@<!___\@!\($\|\s\)/       contains=htmlItalic,@Spell
syn region htmlItalic   start=/\(^\|\s\)_\@<!__\@!/          end=/_\@<!__\@!\($\|\s\)/        contains=htmlBold,@Spell
syn region htmlString   start="]("ms=s+2             end=")"me=e-1
syn region htmlLink     start="\["ms=s+1            end="\]"me=e-1 contains=@Spell
syn region htmlString   start="\(\[.*]: *\)\@<=.*"  end="$"

"define Markdown groups
syn match  mkdLineContinue ".$" contained
syn match  mkdRule      /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  mkdRule      /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  mkdRule      /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  mkdRule      /^\s*-\{3,}$/
syn match  mkdRule      /^\s*\*\{3,5}$/
syn match  mkdListItem  "^\s*[-*+]\s\+"
syn match  mkdListItem  "^\s*\d\+\.\s\+"
syn match  mkdCode      /^\s*\n\(\(\s\{4,}\|[\t]\+\)[^*-+ ].*\n\)\+/
syn region mkdCode      start=/`/                   end=/`/
syn region mkdCode      start=/\s*``[^`]*/          end=/[^`]*``\s*/
syn region mkdBlockquote start=/^\s*>/              end=/$/                 contains=mkdLineContinue,@Spell
syn region mkdCode      start="<pre[^>]*>"         end="</pre>"
syn region mkdCode      start="<code[^>]*>"        end="</code>"

"HTML headings
syn region htmlH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
syn region htmlH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
syn region htmlH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
syn region htmlH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
syn region htmlH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
syn region htmlH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=@Spell

"highlighting for Markdown groups
HtmlHiLink mkdString	    String
HtmlHiLink mkdCode          String
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdLineContinue  Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier


let b:current_syntax = "mkd"

delcommand HtmlHiLink
" vim: ts=8
