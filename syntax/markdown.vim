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
syn region markdownFootnotes matchgroup=markdownDelimiter start="\[^"    end="\]"
syn region markdownId matchgroup=markdownDelimiter        start="\["    end="\]" contained oneline
syn region markdownUrl matchgroup=markdownDelimiter       start="("     end=")"  contained oneline
syn region markdownLink matchgroup=markdownDelimiter      start="\\\@<!\[" end="\]\ze\s*[[(]" contains=@Spell nextgroup=markdownUrl,markdownId skipwhite oneline

" Autolink without angle brackets.
" markdown  inline links:           protocol   optional  user:pass@       sub/domain                 .com, .co.uk, etc      optional port   path/querystring/hash fragment
"                            ------------ _____________________ --------------------------- ________________________ ----------------- __
syntax match   markdownInlineUrl /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/

" Autolink with angle brackets.
syn region markdownInlineUrl matchgroup=markdownDelimiter start="\\\@<!<\(\(coap\|doi\|javascript\|aaa\|aaas\|about\|acap\|cap\|cid\|crid\|data\|dav\|dict\|dns\|file\|ftp\|geo\|go\|gopher\|h323\|http\|https\|iax\|icap\|im\|imap\|info\|ipp\|iris\|iris.beep\|iris.xpc\|iris.xpcs\|iris.lwz\|ldap\|mailto\|mid\|msrp\|msrps\|mtqp\|mupdate\|news\|nfs\|ni\|nih\|nntp\|opaquelocktoken\|pop\|pres\|rtsp\|service\|session\|shttp\|sieve\|sip\|sips\|sms\|snmp,soap.beep\|soap.beeps\|tag\|tel\|telnet\|tftp\|thismessage\|tn3270\|tip\|tv\|urn\|vemmi\|ws\|wss\|xcon\|xcon-userid\|xmlrpc.beep\|xmlrpc.beeps\|xmpp\|z39.50r\|z39.50s\|adiumxtra\|afp\|afs\|aim\|apt,attachment\|aw\|beshare\|bitcoin\|bolo\|callto\|chrome,chrome-extension\|com-eventbrite-attendee\|content\|cvs,dlna-playsingle\|dlna-playcontainer\|dtn\|dvb\|ed2k\|facetime\|feed\|finger\|fish\|gg\|git\|gizmoproject\|gtalk\|hcp\|icon\|ipn\|irc\|irc6\|ircs\|itms\|jar\|jms\|keyparc\|lastfm\|ldaps\|magnet\|maps\|market,message\|mms\|ms-help\|msnim\|mumble\|mvn\|notes\|oid\|palm\|paparazzi\|platform\|proxy\|psyc\|query\|res\|resource\|rmi\|rsync\|rtmp\|secondlife\|sftp\|sgn\|skype\|smb\|soldat\|spotify\|ssh\|steam\|svn\|teamspeak\|things\|udp\|unreal\|ut2004\|ventrilo\|view-source\|webcal\|wtai\|wyciwyg\|xfire\|xri\|ymsgr\):\/\/[^> ]*>\)\@=" end=">"

" Link definitions: [id]: Url (Optional Title)
syn region markdownLinkDef matchgroup=markdownDelimiter   start="^ \{,3}\zs\[" end="]:" oneline nextgroup=markdownLinkDefTarget skipwhite
syn region markdownLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=markdownLinkTitle,markdownLinkDef skipwhite skipnl oneline
syn region markdownLinkTitle matchgroup=markdownDelimiter start=+"+     end=+"+  contained
syn region markdownLinkTitle matchgroup=markdownDelimiter start=+'+     end=+'+  contained
syn region markdownLinkTitle matchgroup=markdownDelimiter start=+(+     end=+)+  contained

"define Markdown groups
syn match  markdownLineContinue ".$" contained
syn match  markdownLineBreak    /  \+$/
syn region markdownBlockquote   start=/^\s*>/                   end=/$/ contains=markdownLineBreak,markdownLineContinue,@Spell
syn region markdownCode         start=/\(\([^\\]\|^\)\\\)\@<!`/ end=/\(\([^\\]\|^\)\\\)\@<!`/
syn region markdownCode         start=/\s*``[^`]*/              end=/[^`]*``\s*/
syn region markdownCode         start=/^\s*```\s*[0-9A-Za-z_-]*\s*$/          end=/^\s*```\s*$/
syn region markdownCode         start=/\s*\~\~[^\~]*/              end=/[^\~]*\~\~\s*/
syn region markdownCode         start=/^\s*\~\~\~\s*[0-9A-Za-z_-]*\s*$/          end=/^\s*\~\~\~\s*$/
syn region markdownCode         start="<pre[^>]*>"              end="</pre>"
syn region markdownCode         start="<code[^>]*>"             end="</code>"
syn region markdownFootnote     start="\[^"                     end="\]"
syn match  markdownCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  markdownIndentCode   /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syn match  markdownListItem     "^\s*[-*+]\s\+"
syn match  markdownListItem     "^\s*\d\+\.\s\+"
syn region markdownNonListItemBlock start="\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@markdownNonListItem,@Spell
syn match  markdownRule         /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  markdownRule         /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  markdownRule         /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  markdownRule         /^\s*-\{3,}$/
syn match  markdownRule         /^\s*\*\{3,5}$/

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
  syn region markdownMath matchgroup=markdownDelimiter start="\\\@<!\$" end="\$"
  syn region markdownMath matchgroup=markdownDelimiter start="\\\@<!\$\$" end="\$\$"
endif

" YAML frontmatter
if get(g:, 'vim_markdown_frontmatter', 0)
  syn include @yamlTop syntax/yaml.vim
  syn region Comment matchgroup=markdownDelimiter start="\%^---$" end="^---$" contains=@yamlTop
endif

syn cluster markdownNonListItem contains=htmlItalic,htmlBold,htmlBoldItalic,markdownFootnotes,markdownInlineUrl,markdownLink,markdownLinkDef,markdownLineBreak,markdownBlockquote,markdownCode,markdownIndentCode,markdownListItem,markdownRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,markdownMath

"highlighting for Markdown groups
HtmlHiLink markdownString	    String
HtmlHiLink markdownCode          String
HtmlHiLink markdownIndentCode    String
HtmlHiLink markdownFootnote    Comment
HtmlHiLink markdownBlockquote    Comment
HtmlHiLink markdownLineContinue  Comment
HtmlHiLink markdownListItem      Identifier
HtmlHiLink markdownRule          Identifier
HtmlHiLink markdownLineBreak     Todo
HtmlHiLink markdownFootnotes     htmlLink
HtmlHiLink markdownLink          htmlLink
HtmlHiLink markdownUrl           htmlString
HtmlHiLink markdownInlineUrl     htmlLink
HtmlHiLink markdownId            Identifier
HtmlHiLink markdownLinkDef       markdownId
HtmlHiLink markdownLinkDefTarget markdownUrl
HtmlHiLink markdownLinkTitle     htmlString
HtmlHiLink markdownMath          Statement
HtmlHiLink markdownDelimiter     Delimiter

" Automatically insert bullets
setlocal formatoptions+=r
" Do not automatically insert bullets when auto-wrapping with text-width
setlocal formatoptions-=c
" Accept various markers as bullets
setlocal comments=b:*,b:+,b:-

" Automatically continue blockquote on line break
setlocal comments+=b:>

let b:current_syntax = "markdown"

delcommand HtmlHiLink
" vim: ts=8
