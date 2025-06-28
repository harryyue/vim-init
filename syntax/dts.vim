" Vim syntax file
" Language:	dts/dtsi (device tree files)
" Maintainer:	Daniel Mack <vim@zonque.org>
" Last Change:	2013 Oct 20

if exists("b:current_syntax")
  finish
endif

syntax match  dtsReference      "&[[:alpha:][:digit:]_]\+"
syntax match  dtsPropertyKey       "[[:space:]]*[[:alpha:][:digit:]-_,]*[[:space:]]\+\ze="
syntax match  dtsProperty       "[[:space:]]*[[:alpha:][:digit:]-_,]\+\ze;"
syntax region dtsBinaryProperty start="\[" end="\]" 
syntax match  dtsStringProperty "\".*\""
syntax match  dtsKeyword        "/.\{-1,\}/"
syntax match  dtsLabel          "^[[:space:]]*[[:alpha:][:digit:]_]\+:"
syntax match  dtsNode           /[[:alpha:][:digit:]-_,]\+\(@[0-9a-fA-F]\+\|\)[[:space:]]*{/he=e-1
syntax region dtsCellProperty   start="<" end=">" contains=dtsReference,dtsBinaryProperty,dtsStringProperty,dtsComment
syntax region dtsComment        start="/\*"  end="\*/"
syntax region dtsCommentInner   start="/\*"  end="\*/"
syntax match  dtsCommentLine    "//.*$"
syntax region dtsIncluded       start=+"+ skip=+\\\\\|\\"+ end=+"+ contained
syntax match  dtsIncluded       "<[^>]*>" contained
syntax match  dtsInclude        "^\s*\zs\(%:\|#\)\s*include\>\s*["<]" contains=dtsIncluded
syntax region dtsDefine         start="^\s*\zs\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" contains=dtsCommentInner,dtsCommentLine
syntax region dtsPreCondit      start="^\s*\zs\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" keepend contains=dtsCommentInner,dtsCommentLine
syntax match  dtsPreConditMatch display "^\s*\zs\(%:\|#\)\s*\(else\|endif\)\>"

" Origin Setting
"hi def link dtsCellProperty     Number
"hi def link dtsBinaryProperty   Number
"hi def link dtsStringProperty   String
"hi def link dtsKeyword          Include
"hi def link dtsLabel            Label
"hi def link dtsNode             Structure
"hi def link dtsReference        Macro
"hi def link dtsComment          Comment
"hi def link dtsCommentInner     Comment
"hi def link dtsCommentLine      Comment

" Custom color
hi def link dtsCellProperty     Number
hi def link dtsBinaryProperty   Number
hi def link dtsStringProperty   String
"hi def link dtsKeyword          Include
hi dtsKeyword               ctermfg=242 guifg=firebrick
hi def link dtsLabel            Identifier
hi def link dtsNode             Statement
hi def link dtsReference        Macro
hi def link dtsComment          Comment
hi def link dtsCommentInner     Comment
hi def link dtsCommentLine      Comment
hi def link dtsInclude          WarningMsg
hi def link dtsIncluded         Underlined
"hi def link dtsDefine           SignColumn
"hi def link dtsPreCondit        SignColumn
"hi def link dtsPreConditMatch   SignColumn
hi dtsDefine                    ctermfg=4 guifg=DarkMagenta
hi dtsPreCondit                 ctermfg=4 guifg=DarkMagenta
hi dtsPreConditMatch            ctermfg=4 guifg=DarkMagenta
"hi def link dtsPropertyKey     SignColumn
hi dtsPropertyKey               ctermfg=48 guifg=firebrick
"hi def link dtsProperty         Type
hi dtsProperty                  ctermfg=130 guifg=brown
