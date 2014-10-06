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

"additions to HTML groups
syn region htmlItalic start="\\\@<!\*\S\@=" end="\S\@<=\\\@<!\*" keepend oneline
syn region htmlItalic start="\(^\|\s\)\@<=_\|\\\@<!_\([^_]\+\s\)\@=" end="\S\@<=_\|_\S\@=" keepend oneline
syn region htmlBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend oneline
syn region htmlBold start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend oneline
syn region htmlBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend oneline
syn region htmlBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend oneline

" [link](URL) | [link][id] | [link][]
syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
syn region mkdID matchgroup=mkdDelimiter        start="\["    end="\]" contained oneline
syn region mkdURL matchgroup=mkdDelimiter       start="("     end=")"  contained oneline
syn region mkdLink matchgroup=mkdDelimiter      start="\\\@<!\[" end="\]\ze\s*[[(]" contains=@Spell nextgroup=mkdURL,mkdID skipwhite oneline

" Autolink without angle brackets.
" mkd  inline links:           protocol   optional  user:pass@       sub/domain                 .com, .co.uk, etc      optional port   path/querystring/hash fragment
"                            ------------ _____________________ --------------------------- ________________________ ----------------- __
syntax match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/

" Autolink with angle brackets.
syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\(\(coap\|doi\|javascript\|aaa\|aaas\|about\|acap\|cap\|cid\|crid\|data\|dav\|dict\|dns\|file\|ftp\|geo\|go\|gopher\|h323\|http\|https\|iax\|icap\|im\|imap\|info\|ipp\|iris\|iris.beep\|iris.xpc\|iris.xpcs\|iris.lwz\|ldap\|mailto\|mid\|msrp\|msrps\|mtqp\|mupdate\|news\|nfs\|ni\|nih\|nntp\|opaquelocktoken\|pop\|pres\|rtsp\|service\|session\|shttp\|sieve\|sip\|sips\|sms\|snmp,soap.beep\|soap.beeps\|tag\|tel\|telnet\|tftp\|thismessage\|tn3270\|tip\|tv\|urn\|vemmi\|ws\|wss\|xcon\|xcon-userid\|xmlrpc.beep\|xmlrpc.beeps\|xmpp\|z39.50r\|z39.50s\|adiumxtra\|afp\|afs\|aim\|apt,attachment\|aw\|beshare\|bitcoin\|bolo\|callto\|chrome,chrome-extension\|com-eventbrite-attendee\|content\|cvs,dlna-playsingle\|dlna-playcontainer\|dtn\|dvb\|ed2k\|facetime\|feed\|finger\|fish\|gg\|git\|gizmoproject\|gtalk\|hcp\|icon\|ipn\|irc\|irc6\|ircs\|itms\|jar\|jms\|keyparc\|lastfm\|ldaps\|magnet\|maps\|market,message\|mms\|ms-help\|msnim\|mumble\|mvn\|notes\|oid\|palm\|paparazzi\|platform\|proxy\|psyc\|query\|res\|resource\|rmi\|rsync\|rtmp\|secondlife\|sftp\|sgn\|skype\|smb\|soldat\|spotify\|ssh\|steam\|svn\|teamspeak\|things\|udp\|unreal\|ut2004\|ventrilo\|view-source\|webcal\|wtai\|wyciwyg\|xfire\|xri\|ymsgr\):\/\/[^> ]*>\)\@=" end=">"

" Link definitions: [id]: URL (Optional Title)
syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"define Markdown groups
syn match  mkdLineContinue ".$" contained
syn match  mkdLineBreak    /  \+$/
syn region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLineBreak,mkdLineContinue,@Spell
syn region mkdCode         start=/\(\([^\\]\|^\)\\\)\@<!`/ end=/\(\([^\\]\|^\)\\\)\@<!`/
syn region mkdCode         start=/\s*``[^`]*/              end=/[^`]*``\s*/
syn region mkdCode         start=/^\s*```\s*[0-9A-Za-z_-]*\s*$/          end=/^\s*```\s*$/
syn region mkdCode         start="<pre[^>]*>"              end="</pre>"
syn region mkdCode         start="<code[^>]*>"             end="</code>"
syn region mkdFootnote     start="\[^"                     end="\]"
syn match  mkdCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdIndentCode   /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syn match  mkdListItem     "^\s*[-*+]\s\+"
syn match  mkdListItem     "^\s*\d\+\.\s\+"
syn region mkdNonListItemBlock start="\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syn match  mkdRule         /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  mkdRule         /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  mkdRule         /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  mkdRule         /^\s*-\{3,}$/
syn match  mkdRule         /^\s*\*\{3,5}$/

"HTML headings
syn region htmlH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
syn region htmlH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
syn region htmlH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
syn region htmlH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
syn region htmlH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
syn region htmlH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=@Spell

if get(g:, 'vim_markdown_math', 0)
  syn region mkdMath matchgroup=mkdDelimiter start="\\\@<!\$" end="\$"
  syn region mkdMath matchgroup=mkdDelimiter start="\\\@<!\$\$" end="\$\$"
endif

" YAML frontmatter
if get(g:, 'vim_markdown_frontmatter', 0)
  syn include @yamlTop syntax/yaml.vim
  syn region Comment matchgroup=mkdDelimiter start="\%^---$" end="^---$" contains=@yamlTop
endif

syn cluster mkdNonListItem contains=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdIndentCode,mkdListItem,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath

"highlighting for Markdown groups
HtmlHiLink mkdString	    String
HtmlHiLink mkdCode          String
HtmlHiLink mkdIndentCode    String
HtmlHiLink mkdFootnote    Comment
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdLineContinue  Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Todo
HtmlHiLink mkdFootnotes     htmlLink
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdInlineURL     htmlLink
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString
HtmlHiLink mkdMath          Statement
HtmlHiLink mkdDelimiter     Delimiter

" Automatically insert bullets
setlocal formatoptions+=r
" Do not automatically insert bullets when auto-wrapping with text-width
setlocal formatoptions-=c
" Accept various markers as bullets
setlocal comments=b:*,b:+,b:-

" Automatically continue blockquote on line break
setlocal comments+=b:>

let b:current_syntax = "mkd"

delcommand HtmlHiLink
" vim: ts=8
