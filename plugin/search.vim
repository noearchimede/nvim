"                            ┌─────────────────┐
"                            │ Search function │
"                            └─────────────────┘

" Implementation of a custom search “plugin”, i.e. a set of mappings and
" commands that provide a simple interface to search and replace within files
" or directories.
" While these functions may be useful, this is mainly an execise in writing
" configuration files for Vim.


" – Table of contents ––––––––––––––––––––––––––––––––––––––––––––––––––––––––

" @Interface
"     @Mappings
"     @Comamnds
" @Functions
"     @Vimrc_Search
"     @Vimrc_SearchReplace
"     @Vimrc_SearchTerminate




" ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
"  @Mappings
" ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


" – @Mappings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

" Search Function: call Vimrc_Search
nnoremap <silent> <leader>ht :Search tab<CR>
vnoremap <silent> <leader>ht :<C-U>SearchVisual tab<CR>
vnoremap <silent> <leader>HT :SearchVisualIgnorecase tab<CR>
" Search Background: call Vimrc_Search but do not show results right away
nnoremap <silent> <leader>hb :Search background<CR>
vnoremap <silent> <leader>hb :<C-U>SearchVisual background<CR>
vnoremap <silent> <leader>HB :<C-U>SearchVisual background<CR>
" Search Vsplit: call Vimrc_Search but do not show results right away
nnoremap <silent> <leader>hv :Search vsplit<CR>
vnoremap <silent> <leader>hv :<C-U>SearchVisual vsplit<CR>
vnoremap <silent> <leader>HV :<C-U>SearchVisual vsplit<CR>
" Search Word: call Vimrc_Search to search the word under the cursor
nnoremap <silent> <leader>hw :SearchWord tab<CR>
nnoremap <silent> <leader>HW :SearchWordIgnorecase tab<CR>
" Search Edit: within the vimrc_search results, replace
nnoremap <silent> <leader>hr :SearchReplace<CR>
" Search Quit: close the results of the previous search, if any
nnoremap <silent> <leader>hq :SearchTerminate<CR>
" Search ReLoad: repeat the same search command
nnoremap <silent> <leader>hl :SearchReload<CR>
" Search Next_Previous: move between search results
nnoremap <silent> <leader>hn :SearchNext<CR>
nnoremap <silent> <leader>hp :SearchPrevious<CR>


" – @Commands ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

" Call search function with any number of arguments (they all are optional)
command! -nargs=* SearchFunction         :call Vimrc_Search(<f-args>)

" Call search function with no query text or scope, with optional 'mode' argument.
command! -nargs=? Search                 :call Vimrc_Search(<f-args>, '?')
" Search visual selection, with optional 'mode' argument
command! -nargs=? SearchVisual           :call Vimrc_Search(<f-args>, 'lC', Vimrc_GetVisualSelection())
" Search visual selection in case insensitive mode, with optional 'mode' argument
command! -nargs=? SearchVisualIgnorecase :call Vimrc_Search(<f-args>, 'lc', Vimrc_GetVisualSelection())
" Search word under cursor
command! -nargs=? SearchWord             :call Vimrc_Search(<f-args>, 'wlC', expand('<cword>'))
" Search word under cursor in case insensitive mode
command! -nargs=? SearchWordIgnorecase   :call Vimrc_Search(<f-args>, 'wlc', expand('<cword>'))

" Move between search results
command! SearchNext                      :call Vimrc_SearchMove('next')
command! SearchPrevious                  :call Vimrc_SearchMove('previous')
" Call replace function on current search results
command! SearchReplace                   :call Vimrc_SearchReplace()
" Terminate search
command! SearchTerminate                 :call Vimrc_SearchTerminate()
" Perform same search again (to see if results changed)
command! SearchReload                    :call Vimrc_SearchReloadResults()




" ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
"  @Functions
" ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


" – @Vimrc_Search ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

" Arguments:
" mode:   [optional, default: 'tab'] determines how to present the search
"         results. Valid values are:
"       - 'background': do not change or show any buffers/splits/tabs, just
"          print a message when the results are in the quickfix list
"       - 'tab': open a new tab and show the search results there
"       - 'split: like 'tab', but in a split
"       - 'vsplit: like 'tab', but in a vertical split
" options:  [optional, default: '0'] search options. Add the corresponding
"           letter to enable an option.
"           - '0' (zero): if options=0, then use the default options (as if
"             the argument was not provided)
"           - '?': ask which options to use in a promt
"           - 'w': match word, i.e. add \< and \> around query
"           - 'C'/'c': force a case sensitive/insensitive search. Only one can
"             be provided; if none the value of `ignorecase` is applied
"           - 'v'/'m'/'M'/'V'/'l': force a very magic/magic/nomagic/very
"             nomagic/literal search. The latter ('literal') is
"             a 'very-very-nomagic' search, where in addition to using '\V'
"             all backslashes and separator characters in the search string
"             are escaped automatically. This makes it impossible to escape
"             any other character and thus use
"             regex, but allows to e.g. copy-paste code in the search prompt
"             (or argument) and have it searched literally. Only one can be
"             provided. If none is provided the current value of 'magic' is
"             used (i.e. either \m or \M)
" query:  [optional] the search text. If not provided (or empty) the user will
"         be asked to insert some text.
" scope:  [optional] the scope of the search. If not provided the user will be
"         asked in a promt. Valid values are:
"       - 'file': search in current file,
"       - 'siblings': files in the same directory, not recursive
"       - 'siblings_rec': files and folders in the same directory, recursive
"       - 'cwd': current working directory, recursive
"       - 'ask': user to insert a search directory
"       - 'path': the next argument must be a valid path for :vimgrep (it will
"         not be checked, if not vaild the search will simply fail)
" path*: [*only if scope='path']: the path argument for :vimgrep
function! Vimrc_Search(...)

    " get the optional parameters
    let mode = a:0 > 0 ? a:1 : 'tab'
    let options_string = a:0 > 1 ? a:2 : '?' " parameter omitted: ask
    if options_string == '0' | let options_string = '' | endif " 0: use default ->  no options
    let query = a:0 > 2 ? a:3 : ''     " ask the user in a prompt
    let scope = a:0 > 3 ? a:4 : ''     " ask the user in a prompt
    " input_path is linked to the value of scope
    let input_path = a:0 > 4 ? a:5 : ''
    if (scope == 'path' && input_path == '')
        echo "A path must be provided if scope='path'"
        return
    endif

    "––– Set search options –––

    if options_string == '?'
        while 1
            let options_string = input("Search options (may be empty) [w, c/C, v/m/M/V/l, ?]: ", get(g:, "vimrc_search_replace_options_suggestion", ''))
            " save answer as default for the next call of this function
            let g:vimrc_search_replace_options_suggestion = options_string
            if options_string == '?'
                redraw
                echo "Select at most one character for each line, then hit <Enter>:" .
                            \ "\n -  w (match word): add \\< and \\> around the query" . 
                            \ "\n -  c/C (force case mode): perform a case insensitive/sensitive search" .
                            \ "\n -  v/m/M/V/l (force magic mode): perform a very magic/magic/nonmagic/very nonmagic/literal search ('literal' completely disables regex)" .
                            \ "\n -  ? print this list"
            else | break | endif
        endwhile
        redraw
    endif
                        

    if (stridx(options_string, 'C') >= 0) | let case_mode = '\C'
    elseif (stridx(options_string, 'c') >= 0) | let case_mode = '\c'
    else | let case_mode = '' | endif
    let whole_word = (stridx(options_string, 'w') >= 0) ? 1 : 0
    if (stridx(options_string, 'v') >= 0) | let magic_mode = '\v'
    elseif (stridx(options_string, 'm') >= 0) | let magic_mode = '\m'
    elseif (stridx(options_string, 'M') >= 0) | let magic_mode = '\M'
    elseif (stridx(options_string, 'V') >= 0) | let magic_mode = '\V'
    elseif (stridx(options_string, 'l') >= 0) | let magic_mode = 'literal'
    " by default use very-nonmagic mode and also escape any backslashes in the
    " query. This allows e.g. to paste in virtually any piece of content and
    " search it literally, which is the main use for this function
    else | let magic_mode = ''
    endif

    "––– Build query string –––

    let sep = '/'
    if query == ""
        " display current options
        redraw
        let current_options_text = "Current search options: "
        if magic_mode == 'literal' | let current_options_text .= "literal match (no regex)"
        elseif magic_mode != '' | let current_options_text .= "magic mode " . magic_mode
        else | let current_options_text .= "default magic (" . (&magic ? "magic" : "nomagic") . ")"
        endif
        if case_mode == '\C' | let current_options_text .= ", case sensitive"
        elseif case_mode == '\c' | let current_options_text .= ", case insensitive"
        elseif case_mode == '' | let current_options_text .= ", default case sensitivity (" . (&ignorecase ? "ignorecase" : "noignorecase") . ")"
        endif
        let current_options_text .= whole_word ? ", only match within words" : ""
        echo current_options_text
        " request query text
        let query = input("Search: ", get(g:, "vimrc_search_replace_search_suggestion", ''))
        " save answer as default for the next call of this function
        let g:vimrc_search_replace_search_suggestion = query
        redraw
    endif
    " if literal mode set magic to very-nomagic and escape backslash and
    " the separator (regardless of wheter the query was inputted just now or
    " was given as an argument)
    if magic_mode == 'literal'
        let magic_mode = '\V'
        " for the escaped characters see https://stackoverflow.com/a/53498890
        " this 
        let query = substitute(escape(query, sep . '\'), '\n', '\\n', 'ge')
    endif
    " do not allow an empty query
    if query == ''
        echo "Search string empty"
        return
    endif
    " set auxiliary parts of the query string
    let query_magic = magic_mode
    let query_prefix = case_mode
    let query_prefix .= whole_word ? '\<' : ''
    let query_suffix = whole_word ? '\>' : ''

    "––– Build search scope string –––
    
    let previous_scope = get(g:, 'vimrc_search_replace_scope_suggestion', [0, 0])
    if scope == ''
        redraw
        while 1
            echo "Search: " . query
            let scope_options_list = "Scope [f, s, d, w, p, l, ?]"
            if previous_scope == [0, 0] | let scope_options_list .= ':'
            else | let scope_options_list .= ' (empty: ' . previous_scope[0] . '):'
            endif
            echo scope_options_list
            " get a single character (no need to hit <Enter>
            let input_val = nr2char(getchar())
            if input_val == 'f' | let scope = 'file' | break
            elseif input_val == 's' | let scope = 'siblings' | break
            elseif input_val == 'd' | let scope = 'siblings_rec' | break
            elseif input_val == 'w' | let scope = 'cwd' | break
            elseif input_val == 'p' | let scope = 'ask_single' | break
            elseif input_val == 'l' | let scope = 'ask_multiple' | break
            elseif input_val == nr2char(13) " Enter
                if previous_scope != [0, 0]
                    let input_val = previous_scope[0]
                    let scope = previous_scope[1]
                    break
                endif
            endif
            " No special case needed for ?, help is printed anyway.  Also, the
            " 'ask' and 'path' arguments are equivalent here, so only one is
            " implemented
        redraw
        echo "Possible values are:" .
                    \ "\nf (file): current file" . 
                    \ "\ns (siblings): all files in the same directory" .
                    \ "\nd (directory): all files in the same directory, recursive" .
                    \ "\nw (working dir.): all files in the CWD, recursive" . 
                    \ "\np (path...): manually select a directory" . 
                    \ "\nl (list...): manually select multiple directories" . 
                    \ "\n? print this list"
                    \ "\n(Note: hidden files and folders are never included in recursive searches)"
        endwhile
        redraw
    endif
    if exists('input_val')
        let g:vimrc_search_replace_scope_suggestion = [input_val, scope]
    endif

    let do_not_escape_search_files = 0  " << this can be set to 1 to disable the escaping function after this if block
    " set the correct file match string.
    if scope == 'ask_single' " this is the 'path' option in the prompt (not the same as 'path' below!)
        echo "Enter a search path, absolute or relative. Use '*' and/or '**/'to search multiple files."
        echo "Current working directory is " . getcwd()
        let search_files_tmp = input("Search path: ", get(g:, 'vimrc_search_replace_path_suggestion', ''), 'file')
        let g:vimrc_search_replace_path_suggestion = search_files_tmp
        " trim leading and trailing spaces
        let search_files_tmp = trim(search_files_tmp)
        " escape any spaces that are not escaped yet
        let search_files = substitute(search_files_tmp, '\\\@<! ', '\\ ', 'g')
    elseif scope == 'ask_multiple' " this is the 'path' option in the prompt (not the same as 'path' below!)
        " previous list: if there is one ask whether to use it or write a new one
        let use_prev_list = 'n'
        if(get(g:, 'vimrc_search_replace_path_suggestion', '') != '')
            echo "Use previous list? [y/n]"
            echo get(g:, 'vimrc_search_replace_path_suggestion', '')
            while 1
                let answ_char = getchar()
                if nr2char(answ_char) == 'y'
                    let use_prev_list = 1
                    break
                elseif nr2char(answ_char) == 'n'
                    let use_prev_list = 0
                    break
                else
                    echo "Type either 'y' or 'n', then hit Enter"
                endif
            endwhile
        endif
        if use_prev_list == 1
            " use previous list (which at this point we know exists
            let search_files = g:vimrc_search_replace_path_suggestion
        else
            " ask user to insert new list
            echo "Enter one or more search paths, absolute or relative. Use '*' and/or '**/'to search multiple files."
            echo "Current working directory is " . getcwd()
            let search_files = ''
            let counter = 1
            while 1
                if counter == 1 
                    let search_files_tmp = input("Search path #" . counter . " (empty to interrupt): ", '', 'file')
                else
                    let search_files_tmp = input("Search path #" . counter . " (empty to continue) : ", '', 'file')
                endif
                "vvvvvvv this seems to have the effect of preserving the 'input' line
                echo ' '
                let counter += 1
                if search_files_tmp == '' | break
                endif
                " trim leading and trailing spaces
                let search_files_tmp = trim(search_files_tmp)
                " escape any spaces that are not escaped yet
                let search_files_tmp = substitute(search_files_tmp, '\\\@<! ', '\\ ', 'g') . ' '
                " append to search string
                let search_files .= search_files_tmp 
            endwhile
        endif
        let g:vimrc_search_replace_path_suggestion = search_files
        let do_not_escape_search_files = 1
    elseif scope == 'file'
        let search_files = expand('%:p')
    elseif scope == 'cwd'
        let search_files = '**/*'
    elseif scope == 'siblings'
        let search_files = expand('%:p:h') . '/*'
    elseif scope == 'siblings_rec'
        let search_files = expand('%:p:h') . '/**/*'
    elseif scope == 'path' " this means that a path was provided in the argument (is not the same as 'ask'!)
        let search_files = input_path
    else
        echo "!!! Error: unknown argument 'scope' passed to function Vimrc_Search"
    endif
    " make sure that the path is absolute. This allows e.g. to repeat the same
    " search later. Also check that it is not empty.
    if search_files == ''
        redraw
        echo "Search path empty"
        return
    elseif (scope != 'ask_multiple') && !(search_files[0] =~ '/' || search_files[0] =~ '\~')
        " path is relative: make absolute
        let search_files = getcwd() . '/' . search_files
    else
        " path is already absolute (may start with '~', which is fine)
        let search_files = search_files
    endif
    " make sure that spaces in the path are escaped (to add more characters
    " that should be escaped add them as an alternative (i.e. using |) within the
    " capture group)
    if !(do_not_escape_search_files)
        let search_files = substitute(search_files, '\m\\\@<!\(\s\)', '\\\1', 'g')
    endif

    "––– Search –––

    " paste together the command string, so that it can be printed later
    let g:vimrc_search_command = 'vimgrep ' . 
                \ sep . query_magic . query_prefix . query . query_suffix . sep . 'gj ' . search_files
    " execute search and catch a no-match error
    try
        redraw
        echo "Executing '" . g:vimrc_search_command . "' (press CTRL-C to interrupt)..."
        exec g:vimrc_search_command
    catch /^Vim\%((\a\+)\)\=:E480:/
        " if there is no match stop the function here
        redraw
        echo "Search command: " . g:vimrc_search_command . "   (note: this does not include hidden files or folders)"
        echo "No match for: " . query . " in " . search_files
        return
    catch /^Vim:Interrupt$/
        " ctrl-C
        redraw
        echo "Search interrupted"
        return
    catch /.*/
        redraw
        echo "An error occurred while searching: " . v:exception
        return
    endtry
    
    " ––– Show results –––

    let nr_results = len(getqflist())
    if nr_results == 0
        redraw
        echo "Search completed successfully, but no results available (error in search script?)"
        return
    endif

    " put the query in the search register so that it can be highlighted with hls
    let @/ = query_magic . query_prefix . query . query_suffix

    " get the current window id. Used fot the `search_close_command`
    let prev_win_id = win_getid()

    " show the results in the way selected through the 'mode' parameter
    if mode == 'background'
        cope
        redraw
        echo "Search command: " . g:vimrc_search_command . "   (note: this does not include hidden files or folders)"
        echo "All ". nr_results . " matches are listed in the quickfix list."
    elseif mode == 'tab'
        silent tabedit
        let res_win_id = win_getid()
        cc 1 " go to first quickfix list element
        silent copen
        redraw
        echo "Search command: " . g:vimrc_search_command . "   (note: this does not include hidden files or folders)"
        echo "All ". nr_results . " matches are listed in the quickfix list."
    elseif (mode == 'split' || mode == 'vsplit')
        if mode == 'vsplit'
            silent vert new
        else 
            silent new
        endif
        let res_win_id = win_getid()
        cc 1 " go to first quickfix list element
        silent copen
        redraw
        echo "Search command: " . g:vimrc_search_command . "   (note: this does not include hidden files or folders)"
        echo "All ". nr_results . " matches are listed in the quickfix list. Explore or edit them in this split, then quit the search to close it."
    else
        echo "!!! Error: unknown argument 'mode' passed to function Vimrc_Search"
    endif

    " create a command to terminate the inspection of the search results.
    if mode == 'background'
        let g:vimrc_search_close_command = "cclose | cexpr []"
    elseif mode == 'tab'
        let g:vimrc_search_close_command = "cclose | cexpr [] |" .
                    \"call win_execute(" . res_win_id  . ", 'close') |" .
                    \"call win_gotoid(" . prev_win_id . ")"
    elseif (mode == 'split' || mode == 'vsplit')
        let g:vimrc_search_close_command = "cclose | cexpr [] |" .
                    \"call win_execute(" . res_win_id  . ", 'close') |" .
                    \"call win_gotoid(" . prev_win_id . ")"
    else
        echo "!!! Error: unknown argument 'mode' passed to function Vimrc_Search"
    endif

    " define a variable to indicate that a replace operation is possible
    " the value is not relevant, only the existance of the variable
    let g:vimrc_search_replace_possible = 1
    " save all variables that will be required in the 'replace' function
    " (the replace command is too complex to be saved as a string here)
    let g:vimrc_search_replace_query_magic = query_magic
    let g:vimrc_search_replace_query_prefix = query_prefix
    let g:vimrc_search_replace_query_suffix = query_suffix
    let g:vimrc_search_replace_query = query
    let g:vimrc_search_replace_sep = sep
    let g:vimrc_search_replace_search_files = search_files
    " This is used as a default value in case of multiple calls of
    " SearchReplace.
    " Put any value here for a first suggestion (e.g. '' or query)
    let g:vimrc_search_replace_replace_suggestion = query

endfunction


" – @Vimrc_SearchReloadResults –––––––––––––––––––––––––––––––––––––––––––––––

function! Vimrc_SearchReloadResults()
    let query = g:vimrc_search_replace_query
    let query_magic = g:vimrc_search_replace_query_magic
    let query_prefix = g:vimrc_search_replace_query_prefix
    let query_suffix = g:vimrc_search_replace_query_suffix
    let search_files = g:vimrc_search_replace_search_files
    let prev_nr_matches = len(getqflist())
    " prompt for confirmation
    redraw
    echo "Search command: " . g:vimrc_search_command
    echo "Do you really want to execute this search again? [y/n]"
    if nr2char(getchar()) == 'y'
        " execute search and catch a no-match error
        try
            redraw
            echo "Executing '" . g:vimrc_search_command . "' (press CTRL-C to interrupt)..."
            exec g:vimrc_search_command
        catch /^Vim\%((\a\+)\)\=:E480:/
            " if there is no match stop the function here
            redraw
            echo "No match for \"" . query . "\" in " . search_files . " NOTE: hidden files and folders are not included."
            echo "Full regex: " . query_magic .  query_prefix . query . query_suffix
            return
        catch /^Vim:Interrupt$/
            " ctrl-C
            redraw
            echo "Search interrupted."
        catch /.*/
            redraw
            echo "An error occurred while searching: " . v:exception
        endtry
        redraw
        echo "Search repeated with same command: " . g:vimrc_search_command . "   (note: this does not include hidden files or folders)"
        echo "Found " . len(getqflist()) . " matches (previously " . prev_nr_matches . "). The quickfix list now contains the new results."
    else
        echo "Operation cancelled (you did not type 'y')."
    endif
endfunction


" – @Vimrc_SearchReplace –––––––––––––––––––––––––––––––––––––––––––––––––––––

function! Vimrc_SearchReplace()
    " check that a replace command exist. This indicates that the last search
    " was not already closed (and that one exists)
    if !exists('g:vimrc_search_replace_possible')    
        echo "Before running this command (Replace) run the Search command"
        return
    endif
    " check that the quickfix list still refers to the last search, and abort
    " otherwise to avoid messing up the result from some other command
    copen  " we need to open the quickfix list to read `w:quickfix_title`
    if w:quickfix_title != ':' . g:vimrc_search_command
        echo "Unable to replace: the quickfix list was changed since the last search"
        return
    endif

    let sep = g:vimrc_search_replace_sep
    let query = g:vimrc_search_replace_query
    let query_magic = g:vimrc_search_replace_query_magic
    let query_prefix = g:vimrc_search_replace_query_prefix
    let query_suffix = g:vimrc_search_replace_query_suffix
    let search_files = g:vimrc_search_replace_search_files
    let suggestion = g:vimrc_search_replace_replace_suggestion

    redraw
    echo "search string: " . query_prefix . query . query_suffix
    echo "search scope: " . search_files
    if query_magic == '' | echo "magic mode: default (" . (&magic ? "magic" : "nomagic") . ")"
    else | echo "Magic mode: " . query_magic
    endif
    let new_text = input("Replace with: ", suggestion)

    let nr_results = len(getqflist())
    while 1
        let answ= input("Replacing '" . query . "' with '" . new_text . "'. " .
                    \ "Would you like to review all " . nr_results .
                    \ " substitutions individually? [y/n] ")
        if (answ == 'y' || answ == 'yes') | let confirm_flag = 'c' | break
        elseif (answ == 'n' || answ == 'no') | let confirm_flag = '' | break
        endif
    endwhile
    try
        exec 'cfdo %s' . sep . query_magic . query_prefix . query . query_suffix . sep .
                    \ new_text . sep . 'g' . confirm_flag . ' | update'
    catch /^Vim\%((\a\+)\)\=:E486:/
        " There is no match
        redraw
        echo "No matches left. Did you already replace all occurrences?"
    catch /^Vim\%((\a\+)\)\=:E37:/
        " Unable to go to next file because of unasved changes
        redraw
        echo "No matches left. Did you already replace all occurrences?"
    catch /^Vim:Interrupt$/
        " ctrl-C
        redraw
        echo "Replacement interrupted. Run this function again to resume"
    catch /.*/
        redraw
        echo "An error occurred while replacing: " . v:exception
    endtry

    let g:vimrc_search_replace_replace_suggestion = new_text

endfunction


" – @Vimrc_SearchTerminate –––––––––––––––––––––––––––––––––––––––––––––––––––

function! Vimrc_SearchTerminate()
    " check that a close command exist. This indicates that the last search
    " was not already closed (and that one exists)
    if !exists('g:vimrc_search_close_command')    
        echo "There isn't any search to terminate"
        return
    endif
    " check that the quickfix list still refers to the last search, and abort
    " otherwise to avoid messing up the result from some other command
    copen  " we need to open the quickfix list to read `w:quickfix_title`
    if w:quickfix_title != ':' . g:vimrc_search_command
        echo "Unable to terminate search: the quickfix list was changed since the last search"
        return
    endif

    " The checks above passed -> terminate the search inspection
    execute g:vimrc_search_close_command
    unlet g:vimrc_search_close_command
    unlet g:vimrc_search_replace_possible
    
endfunction


" – @Vimrc_SearchMove ––––––––––––––––––––––––––––––––––––––––––––––––––––––––

" Arguments:
" action: the kind of movement desired
"       - 'next': go to next result
"       - 'previous': go to previous result
function! Vimrc_SearchMove(action)
    " check that a close command exist. This indicates that the last search
    " was not already closed (and that one exists)
    if !exists('g:vimrc_search_close_command')    
        echo "There aren't any search results to navigate"
        return
    endif
    " check that the quickfix list still refers to the last search, and abort
    " otherwise to avoid messing up the result from some other command
    copen  " we need to open the quickfix list to read `w:quickfix_title`
    if w:quickfix_title != ':' . g:vimrc_search_command
        echo "Unable to navigate search results: the quickfix list was changed since the last search"
        return
    endif

    " move
    if a:action == 'next'
        cnext
    elseif a:action == 'previous'
        cprev
    else
        echo "!!! Error: unknown argument passed to function Vimrc_SearchMove"
    endif

endfunction






