if exists('g:loaded_maven') && !exists('g:reload_maven')
    finish
endif

" Check for Reload {{{1
if exists('g:reload_maven')
    autocmd! MavenAutoDetect
    augroup! MavenAutoDetect

    unmenu Maven

    nunmap maven#run-unittest
    iunmap maven#run-unittest
    nunmap maven#run-unittest-all
    iunmap maven#run-unittest-all
    nunmap maven#switch-unittest-file
    iunmap maven#switch-unittest-file
    iunmap maven#open-test-result
    nunmap maven#open-test-result
endif
"}}}
"
let g:loaded_maven = 1

" Global settings {{{
if !exists("g:maven_auto_set_path")
    let g:maven_auto_set_path = 1
endif
if !exists("g:maven_auto_chdir")
    let g:maven_auto_chdir = 0
endif

if !exists("g:maven_args")
    let g:maven_args = ""
endif

if !exists("g:maven_test_folder_alternates")
    let g:maven_test_folder_alternates = ['', '/test', '..']
endif

" }}}

" Maps {{{
nnoremap <silent> <unique> maven#run-unittest :Mvn test -Dtest=%:t:r -DfailIfNoTests=true<CR>
inoremap <silent> <unique> maven#run-unittest <C-O>:Mvn test -Dtest=%:t:r -DfailIfNoTests=true<CR>
nnoremap <silent> <unique> maven#run-unittest-all :Mvn test -DfailIfNoTests=true<CR>
inoremap <silent> <unique> maven#run-unittest-all <C-O>:Mvn test -DfailIfNoTests=true<CR>
nnoremap <silent> <unique> maven#switch-unittest-file :call <SID>SwitchUnitTest()<CR>
inoremap <silent> <unique> maven#switch-unittest-file <C-O>:call <SID>SwitchUnitTest()<CR>
nnoremap <silent> <unique> maven#open-test-result :call <SID>OpenTestResult()<CR>
inoremap <silent> <unique> maven#open-test-result <C-O>:call <SID>OpenTestResult()<CR>
" }}}

" Autocmds {{{
augroup MavenAutoDetect
    autocmd MavenAutoDetect BufNewFile,BufReadPost *.* call s:SetupMavenEnv()
    autocmd MavenAutoDetect BufWinEnter *.* call s:AutoChangeCurrentDirOfWindow()
    autocmd MavenAutoDetect QuickFixCmdPost make call s:ProcessQuickFixForMaven()
augroup END
" }}}

" Commands {{{
command! -bang -nargs=+ -complete=custom,s:CompleteMavenLifecycle Mvn call s:RunMavenCommand(<q-args>, expand("<bang>"))
command! -nargs=1 -complete=customlist,s:ListCandidatesOfTest MvnEditTestCode call s:EditTestCode(<q-args>)

" TODO: Fix autocomplete for new options
" command! -nargs=+ -complete=custom,s:CmdCompleteListPackage MvnEditFile call s:EditFile(<q-args>)
" command! -nargs=+ -complete=custom,s:CmdCompleteListPackage MvnNewMainFile call s:EditFile("-t=main ".<q-args>)
" command! -nargs=+ -complete=custom,s:CmdCompleteListPackage MvnNewTestFile call s:EditFile("-t=test ".<q-args>)
command! -nargs=+ MvnEditFile call s:EditFile(<q-args>)
command! -nargs=+ MvnEditMainFile call s:EditFile("-t=main ".<q-args>)
command! -nargs=+ MvnEditTestFile call s:EditFile("-t=test ".<q-args>)
command! MvnEditQueryBundle call s:EditFile("-s=resources ".fnamemodify(bufname("%"), ":p:t:r").".xml")
command! MvnEditProperties call s:EditFile("-s=resources ".fnamemodify(bufname("%"), ":p:t:r")."_en_US.properties")
" }}}

" Menu {{{
210menu <silent> Maven.Run\ File\ UnitTest<Tab><F5> maven#run-unittest
210menu <silent> Maven.Run\ UnitTest<Tab><Ctrl-F5> maven#run-unittest-all
210menu <silent> Maven.Switch\ Unit\ Test\ File<Tab><F6> maven#switch-unittest-file
210menu <silent> Maven.Open\ Unit\ Test\ Result<Tab><Ctrl-F6> maven#open-test-result
210imenu <silent> Maven.Run\ File\ UnitTest<Tab><F5> maven#run-unittest
210imenu <silent> Maven.Run\ UnitTest<Tab><Ctrl-F5> maven#run-unittest-all
210imenu <silent> Maven.Switch\ Unit\ Test\ File<Tab><F6> maven#switch-unittest-file
210imenu <silent> Maven.Open\ Unit\ Test\ Result<Tab><Ctrl-F6> maven#open-test-result

210menu <silent> Maven.Phrase.Clean.pre-clean :Mvn pre-clean<CR>
210menu <silent> Maven.Phrase.Clean.clean :Mvn clean<CR>
210menu <silent> Maven.Phrase.Clean.post-clean :Mvn post-clean<CR>

210menu <silent> Maven.Phrase.Default.validate :Mvn validate<CR>
210menu <silent> Maven.Phrase.Default.initialize :Mvn initialize<CR>
210menu <silent> Maven.Phrase.Default.generate-sources :Mvn generate-sources<CR>
210menu <silent> Maven.Phrase.Default.process-sources :Mvn process-sources<CR>
210menu <silent> Maven.Phrase.Default.generate-resources :Mvn generate-resources<CR>
210menu <silent> Maven.Phrase.Default.process-resources :Mvn process-resources<CR>
210menu <silent> Maven.Phrase.Default.compile :Mvn compile<CR>
210menu <silent> Maven.Phrase.Default.process-classes :Mvn process-classes<CR>
210menu <silent> Maven.Phrase.Default.generate-test-sources :Mvn generate-test-sources<CR>
210menu <silent> Maven.Phrase.Default.process-test-sources :Mvn process-test-sources<CR>
210menu <silent> Maven.Phrase.Default.generate-test-resources :Mvn generate-test-resources<CR>
210menu <silent> Maven.Phrase.Default.process-test-resources :Mvn process-test-resources<CR>
210menu <silent> Maven.Phrase.Default.test-compile :Mvn test-compile<CR>
210menu <silent> Maven.Phrase.Default.process-test-classes :Mvn process-test-classes<CR>
210menu <silent> Maven.Phrase.Default.post-process :Mvn post-process<CR>
210menu <silent> Maven.Phrase.Default.test :Mvn test<CR>
210menu <silent> Maven.Phrase.Default.prepare-package :Mvn prepare-package<CR>
210menu <silent> Maven.Phrase.Default.package :Mvn package<CR>
210menu <silent> Maven.Phrase.Default.pre-integration-test :Mvn pre-integration-test<CR>
210menu <silent> Maven.Phrase.Default.integration-test :Mvn integration-test<CR>
210menu <silent> Maven.Phrase.Default.post-integration-test :Mvn post-integration-test<CR>
210menu <silent> Maven.Phrase.Default.verify :Mvn verify<CR>
210menu <silent> Maven.Phrase.Default.install :Mvn install<CR>
210menu <silent> Maven.Phrase.Default.deploy :Mvn deploy<CR>

210menu <silent> Maven.Phrase.Site.pre-site :Mvn pre-site<CR>
210menu <silent> Maven.Phrase.Site.site :Mvn site<CR>
210menu <silent> Maven.Phrase.Site.post-site :Mvn post-site<CR>
210menu <silent> Maven.Phrase.Site.site-deploy :Mvn site-deploy<CR>
" }}}

" Setup the maven environment for current buffer {{{1
function! <SID>SetupMavenEnv()
    let currentBuffer = bufnr("%")

    call maven#setupMavenProjectInfo(currentBuffer)

    if !maven#isBufferUnderMavenProject(currentBuffer)
        return
    endif

    " Setup the paths of current buffer
    if g:maven_auto_set_path == 1
        let currentPath = getbufvar(currentBuffer, "&path")
        let mavenPaths = maven#getListOfPaths(currentBuffer)

        if stridx(currentPath, mavenPaths[0]) == -1
            call setbufvar(currentBuffer, "&path", join(mavenPaths, ",") . "," . &path)
        endif
    endif
    " //:~)
endfunction
"}}}

" Open Surefire test result for the current buffer {{{1
function! <SID>OpenTestResult()
    let targetFileName = s:GetSurefireReportFileName()

    if filereadable(targetFileName)
        if targetFileName =~ '\.java$'
            execute "edit " . targetFileName
        else
            execute "view " . targetFileName
        endif
        return
    endif

    call s:EchoWarning("File not exists:" . targetFileName)
endfunction
function! <SID>GetSurefireReportFileName()
    let triggeredFileName = maven#slashFnamemodify(expand("%"), ":p")
    let currentBuf = bufnr(triggeredFileName)

    if !s:CheckFileInMavenProject(currentBuf)
        return
    endif

    let testSourcePattern = '\v^.+/src/test/java/(.+)\.java$'
    let testNgResultPattern = '\v^.+/target/surefire-reports/junitreports/TEST-(.+)\.xml$'
    let junitResultPattern = '\v^.+/target/surefire-reports/(.+)\.txt$'
    let mavenProjectRoot = maven#getMavenProjectRoot(currentBuf)

    " Open the file of testing or the result of testing, repectively
    if triggeredFileName =~ testSourcePattern
        let fullClassName = substitute(substitute(triggeredFileName, testSourcePattern, '\1', ''), '/', '.', 'g')

        let testNgResultFile = mavenProjectRoot . '/target/surefire-reports/junitreports/TEST-' . fullClassName . ".xml"
        let junitResultFile = mavenProjectRoot . '/target/surefire-reports/' . fullClassName . ".txt"

        if filereadable(testNgResultFile)
            let targetFileName = testNgResultFile
        elseif filereadable(junitResultFile)
            let targetFileName = junitResultFile
        else
            call s:EchoWarning("Can't find result file of testing for: " . fullClassName)
            return
        endif
    elseif triggeredFileName =~ testNgResultPattern
        let targetFileName = substitute(triggeredFileName, testNgResultPattern, '\1', '')
        let targetFileName = mavenProjectRoot . '/src/test/java/' . substitute(targetFileName, '\.', '/', 'g') . ".java"
    elseif triggeredFileName =~ junitResultPattern
        let targetFileName = substitute(triggeredFileName, junitResultPattern, '\1', '')
        let targetFileName = mavenProjectRoot . '/src/test/java/' . substitute(targetFileName, '\.', '/', 'g') . ".java"
    else
        call s:EchoWarning("Can't recognize file: " . triggeredFileName)
        return
    endif
    " //:~)

    return targetFileName
endfunction
"}}}

" Switch between source and test file {{{1
function! <SID>SwitchUnitTest()
    " ==================================================
    " Jump back to the file of test code from the result file of test
    " ==================================================
    let fileName = fnamemodify(bufname("%"), ":t")
    if fileName =~ '^TEST-.\+\.xml$'
        let testFilePattern = matchstr(fileName, '^TEST-\zs.\+\ze\.xml$')
        let testFilePattern = substitute(testFilePattern, '\.', '/', 'g') . '.*'

        let resultFiles = split(glob(maven#getMavenProjectRoot(bufnr("%")) . "/src/**/" . testFilePattern), "\n")
        if len(resultFiles) == 0
            throw "Can't find the file of test code for: " . testFilePattern
        endif

        execute "edit " . resultFiles[0]
        return
    endif
    " //:~)

    update
    let currentBuf = bufnr("%")

    if !s:CheckFileInMavenProject(currentBuf)
        return
    endif

    " ==================================================
    " Recognize the what file type is(source/unit test)
    " ==================================================
    let classNameOfBuf = maven#slashFnamemodify(bufname(currentBuf), ":t:r")
    let fileDir = maven#slashFnamemodify(bufname(currentBuf), ":p:h")
    let fileExtension = maven#slashFnamemodify(bufname(currentBuf), ":e")

    if fileDir !~ '/src/\%(main\|test\)/\w\+'
        call s:EchoWarning("Can't recognize file of code: " . maven#slashFnamemodify(bufname(currentBuf), ":t"))
        return
    endif
    " //:~)

    " ==================================================
    " Compose the corresponding file name
    " ==================================================
    let listOfExistingCandidates = []
    let listOfNewCandidates = []

    if fileDir =~ 'src/main'
        let targetFilePath = s:ConvertToFilePathForTest(classNameOfBuf, fileDir, fileExtension)
    else
        let targetFilePath = s:ConvertToFilePathForSource(classNameOfBuf, fileDir, fileExtension)
    endif

    if targetFilePath == ""
        return
    endif
    " //:~)

    " ==================================================
    " Ask whether to edit a new file if the file doesn't exist
    " ==================================================
    let directory = maven#slashFnamemodify(targetFilePath, ":p:h")
    if !isdirectory(directory)
        if confirm("Directory:[" . directory . "] doesn't exist\nCreate It?", "&Yes\n&No", 1) == 2
            return
        endif

        call mkdir(directory, "p")
    endif
    " //:~)

    if !filereadable(targetFilePath)
        if confirm("File:[".targetFilePath."] does not exist\nCreate it?", "&Yes\n&No", 1) == 2
            return
        endif
    endif

    execute "edit " . targetFilePath
endfunction

function! <SID>ConvertToFilePathForTest(sourceClassName, fileDir, fileExtension)
    " Compose the corresponding file name
    let listOfExistingCandidates = []
    let listOfNewCandidates = []

    " Prepare the list of candidates
    let testDir = substitute(a:fileDir, '/src/main/', '/src/test/', '')
    let listOfCandidates = maven#getCandidateClassNameOfTest(a:sourceClassName)

    let searchDirs = s:BuildListOfSearchDirectories(testDir)

    for searchDir in searchDirs
        for candidate in listOfCandidates
            let candidatePath = searchDir . "/" . candidate . "." . a:fileExtension
            if filereadable(candidatePath)
                call add(listOfExistingCandidates, candidatePath)
            endif

        endfor

        call add(listOfNewCandidates, searchDir."/".listOfCandidates[0].".".a:fileExtension)
    endfor
    " //:~)

    " Ask the user to choose multiple condidates of existing/new test code
    if len(listOfExistingCandidates) == 1
        return listOfExistingCandidates[0]
    elseif len(listOfExistingCandidates) > 0
        let selectedIdx = confirm("Select a test code:\n", s:BuildSelectionOfClassName(listOfExistingCandidates), 1) - 1
        if selectedIdx == -1 || selectedIdx == len(listOfExistingCandidates)
            return
        endif

        return listOfExistingCandidates[selectedIdx]
    elseif len(listOfNewCandidates) > 0
        let selectedIdx = confirm("Edit a new test code:\n", s:BuildSelectionOfClassName(listOfNewCandidates), 1) - 1
        if selectedIdx == -1 || selectedIdx == len(listOfNewCandidates)
            return
        endif

        return listOfNewCandidates[selectedIdx]
    endif
    " //:~)

    throw "Can't figure out a test for: " . a:sourceClassName
endfunction
function! <SID>ConvertToFilePathForSource(testClassName, fileDir, fileExtension)
    let sourceDir = substitute(a:fileDir, '/src/test/', '/src/main/', '')
    let defaultmatch = ''

    let searchDirs = s:BuildListOfSearchDirectories(sourceDir)

    for searchDir in searchDirs
        for matchPattern in s:BuildMatchPatternsForTestClass()
            if a:testClassName =~ matchPattern
                let sourcefile = searchDir . "/" . substitute(a:testClassName, matchPattern, "", "") . "." . a:fileExtension
                if filereadable(sourcefile)
                    return sourcefile
                endif

                " save the first attempt as the default
                if empty(defaultmatch)
                    let defaultmatch = sourcefile
                endif
            endif
        endfor
    endfor

    " Use the first serch directory as the default
    return defaultmatch
endfunction

function! <SID>BuildListOfSearchDirectories(fileDir)
    let searchDirs = []
    " get full path sans trailing slash
    let fullFilePath = fnamemodify(a:fileDir, ":p:h")

    for subDir in g:maven_test_folder_alternates
        if (subDir ==? "..")
            let searchDir = fnamemodify(fullFilePath, ":h")
        else
            let searchDir = fullFilePath.subDir
        endif

        if isdirectory(searchDir)
            call add(searchDirs, searchDir)
        endif
    endfor

    return searchDirs
endfunction

" Build patterns for matching part of class name of testing code
function! <SID>BuildMatchPatternsForTestClass()
    let matchPatterns = []

    for metaClassName in maven#getCandidateClassNameOfTest("<>")
        let beginIndex = match(metaClassName, "<")
        let endIndex = match(metaClassName, ">")

        " There is a prefix in class name of test code
        if beginIndex > 0
            call add(matchPatterns, "^" . strpart(metaClassName, 0, beginIndex))
        endif
        " //:~)
        " There is a suffix in class name of test code
        if endIndex < strlen(metaClassName) - 1
            call add(matchPatterns, strpart(metaClassName, endIndex + 1) . "$")
        endif
        " //:~)
    endfor

    return matchPatterns
endfunction

function! <SID>BuildSelectionOfClassName(listOfPath)
    let listOfSelection = []

    for path in a:listOfPath
        call add(listOfSelection, fnamemodify(path, ":t:r"))
    endfor
    call add(listOfSelection, "*Cancel*") " Add 'Cancel' option

    return join(listOfSelection, "\n")
endfunction
"}}}

" Open a new file given a category, package and file name {{{1
"   MvnEdit <project> <type> <package> <filename>
"       -project - is useful when your vim session's working directory is in the parent folder of the top pom.
"                   This allows you to have cross pom commands.
"       -type    - Can be main or test. If not specified it will take the current buffers value.  If the current buffer
"                   does not have a package it will default to "main".
"       -sources - is the type of source files you're creating; java, js, resources.  If not specified it will use the
"                   extension of the specified filename.
"       package  - is the full package name e.g. com.my_company.my_app.my_componenent.  If not specified it will use the
"                   current buffers value or be omitted.
"       filename - name of the file you wish to edit.  If it doesn't exist it will be created in the correct folder.
"
function! <SID>EditFile(args)
    if !maven#isBufferUnderMavenProject(bufnr("%"))
        throw "Current buffer is not under Maven project"
    endif

    let options = s:ParseArgumentsForMvnEdit(a:args)
    if empty(options)
        return
    endif

    " Prepare the full path name of new file
    let fileFullPath = maven#getMavenProjectRoot(bufnr("%"))
    let fileFullPath .= '/src/' . options.type . '/'
    let fileFullPath .= options.source .'/'

    if has_key(options, "package") && !empty(options.package)
        let fileFullPath .= substitute(options.package, '\.', '/', 'g') . '/'
    endif

    let fileFullPath .= options.filename
    " //:~)

    " Build the tree of directory of new file
    let fileDir = fnamemodify(fileFullPath, ":p:h")
    if !isdirectory(fileDir)
        call mkdir(fileDir, "p")
    endif
    " //:~)

    execute "edit " . fileFullPath
endfunction

" Parse the arguments for MvnEdit
"
"
let s:maven_argument_map = {
            \"p": "project",
            \"t": "type",
            \"s": "source"
            \}
let s:maven_position_map = ["filename", "package"]

function! <SID>ParseArgumentsForMvnEdit(args)
    let arguments = split(a:args, '\s\+')

    let options = {}
    " Look for options in the maven_argument_map.
    for argToken in keys(s:maven_argument_map)

        let argMatch = s:matchArgumentList(argToken, arguments)
        if !empty(argMatch)
            let optionName = s:maven_argument_map[argToken]
            let options[optionName] = argMatch
        endif
    endfor

    " look for the values specifiedin the maven_position_map.  These are specified by
    " position instead of a token.  File name will always be the last argument specified.
    "
    let index = 0
    for item in reverse(arguments)
        if item =~ '\v^[^-].*$' && index < len(s:maven_position_map)
            let options[s:maven_position_map[index]] = item
            let index = index + 1
        endif
    endfor

    " Must at least have spcified a file name
    if empty(options) || !has_key(options, "filename")
        echoerr "EditFile -p(roject)=<project> -t(type)=[main|test] -s(sources)=[java|js|resources] package filename"
        return {}
    endif

    " if source wasn't specified then get it from the file extension
    if !has_key(options,"source") || empty(options.source)
        let options.source = fnamemodify(options.filename, ":e")
    endif

    " if package wasn't specified then get it from the current buffer if possible
    if !has_key(options, "package") || empty(options.package)
        let options.package = s:getPackageFromBuffer()
    endif

    if !has_key(options, "type") || empty(options.type)
        let options.type = s:getTypeFromBuffer()
    endif

    return options
endfunction

function! <SID>matchArgumentList(argToken, arguments)
    for arg in a:arguments
        let matchPattern = '\v^-('.a:argToken.')%(.*)?\=(.*)$'
        if arg =~ matchPattern
            let argMatch = matchlist(arg, matchPattern)
            if argMatch[1] == a:argToken
                return argMatch[2]
            endif
        endif
    endfor

    return ""
endfunction

function! <SID>getPackageFromBuffer()
    let bufpath = fnamemodify(bufname("%"), ":p:h")
    let pattern = '\v%(.*)?\/src\/.{-}\/.{-}\/(.*)$'
    if bufpath =~ pattern
        let packagematch = matchlist(bufpath, pattern)
        return packagematch[1]
    endif

    return ""
endfunction

function! <SID>getTypeFromBuffer()
    let bufpath = fnamemodify(bufname("%"), ":p:h")
    let pattern = '\v%(.*)?\/src\/(.{-})\/.{-}\/.*$'
    if bufpath =~ pattern
        let packagematch = matchlist(bufpath, pattern)
        return packagematch[1]
    endif

    return "main"
endfunction

" Generate list of package sorted by
"   1) height of package's hierarchy and
"   2) literal order
"
" For example:
" 'com.mycompany'
" 'com.mycompany.zoo'
" 'com.mycompany.xyz'
" 'com.mycompany.jdbc.pooling'
function! <SID>CmdCompleteListPackage(argLead, cmdLine, cursorPos)
    let currentCmdArgs = split(a:cmdLine, '\s\+')
    if currentCmdArgs[0] == "MvnNewMainFile"
        let rootOfSource = maven#getMavenProjectRoot(bufnr("%")) . "/src/main/"
    endif
    if currentCmdArgs[0] == "MvnNewTestFile"
        let rootOfSource = maven#getMavenProjectRoot(bufnr("%")) . "/src/test/"
    endif

    " ==================================================
    " Auto-complete the prefix diretories under '/src/{source_type}/*/'
    " ==================================================
    let prefixOption = s:ProcessOptionsForEditNewFile([a:argLead])
    if prefixOption["prefixDef"] != ""
        return s:GetAutoCompleteOfPrefix(rootOfSource, prefixOption)
    endif
    " //:~)

    let prefixOption = s:ProcessOptionsForEditNewFile(currentCmdArgs[1:])

    " ==================================================
    " At the last option, nothing completed
    " ==================================================
    if len(currentCmdArgs) > 3
        return ""
    elseif len(currentCmdArgs) == 3 && prefixOption["prefixDef"] == "" && a:argLead == ""
        return ""
    endif
    " //:~)

    " ==================================================
    " Extract the start directory of auto-complete
    " ==================================================
    let entryDirOfAutoComplete = prefixOption["prefixValue"] != ""  ?
        \ prefixOption["prefixValue"] :
        \ fnamemodify(bufname("%"), ":e")
    " //:~)

    let heading = rootOfSource . entryDirOfAutoComplete . "/"
    let dirsInSrc = split(glob(heading . "**/"), "\n")

    if len(dirsInSrc) == 0
        " Nothing in source directory, give general suffix of domain name
        return "com.\norg.\nidv."
        " //:~)
    endif

    " ==================================================
    " Convert the directories of family to package names
    " ==================================================
    let packages = []
    for dirOfPackage in dirsInSrc
        let packageName = substitute(dirOfPackage, heading, '', '') " Trim heading paths
        let packageName = substitute(packageName, '/', '.', 'g') " Convert the path to format of package
        call add(packages, packageName)
    endfor
    call sort(packages, "s:SortPackageName")
    " //:~)

    return join(packages, "\n")
endfunction

function! <SID>GetAutoCompleteOfPrefix(rootDir, prefixOption)
    let prefixGlob = a:prefixOption["prefixValue"] == "" ? "*/" : a:prefixOption["prefixValue"] . "*/"
    let prefixDirectories = split(glob(a:rootDir . prefixGlob), "\n")

    " ==================================================
    " Trim the root directory of source
    " ==================================================
    let i = 0
    while i < len(prefixDirectories)
        let prefixDirectories[i] = a:prefixOption["prefixDef"] . substitute(prefixDirectories[i], a:rootDir, '', '')
        let prefixDirectories[i] = substitute(prefixDirectories[i], '/$', '', '') " Trim the last '/'(slash)
        let i += 1
    endwhile
    " //:~)

    return join(prefixDirectories, "\n")
endfunction

" Sort name of packages by height of hierarachy and literal name
function! <SID>SortPackageName(leftPackage, rightPackage)
    let heightOfLeftPackage = strlen(substitute(a:leftPackage, '[^.]', '', 'g'))
    let heightOfRightPackage = strlen(substitute(a:rightPackage, '[^.]', '', 'g'))

    " Compare the height of packages' hierarchy
    if heightOfLeftPackage > heightOfRightPackage
        return 1
    elseif heightOfLeftPackage < heightOfRightPackage
        return -1
    endif
    " //:~)

    " Compare the packages' name literally
    if a:leftPackage > a:rightPackage
        return 1
    elseif a:leftPackage < a:rightPackage
        return -1
    endif
    " //:~)

    return 0
endfunction
"}}}

" Open test file that is under /src/test from the current buffer {{{1
function! <SID>EditTestCode(testFileName)
    let pathOfCurrentBuffer = maven#slashFnamemodify(bufname("%"), ":p:h")
    if pathOfCurrentBuffer !~ '/src/main/'
        throw "Editing test code must be under '/src/main'. Current: " . pathOfCurrentBuffer
    endif

    let pathOfTestFile = substitute(pathOfCurrentBuffer, '/src/main/', '/src/test/', '')

    if !isdirectory(pathOfTestFile)
        call mkdir(pathOfTestFile, "p")
    endif

    execute "edit " . pathOfTestFile . "/" . a:testFileName
endfunction


" List the candidates of file name for testing.
" This function is used to generate command completion in VIM.
"
" This result of this function is the file name of candidate.
" For example:
" [
"   "ControllerTest.java",
"   "ControllerTestIT.java",
"   "ControllerTestCase.java",
"   "TestController.java"
" ]
function! <SID>ListCandidatesOfTest(argLead, cmdLine, cursorPos)
    let candidatesOfFileNames = maven#getCandidateClassNameOfTest(maven#slashFnamemodify(bufname("%"), ":t:r"))
    let fileExtension = maven#slashFnamemodify(bufname("%"), ":e")

    let i = 0
    while i < len(candidatesOfFileNames)
        let candidatesOfFileNames[i] = candidatesOfFileNames[i] . "." . fileExtension
        let i += 1
    endwhile

    return candidatesOfFileNames
endfunction
"}}}

" Run a Maven command "{{{1
function! <SID>RunMavenCommand(args, bang)
    update

    let pomFile = s:GetPOMXMLFile(bufnr("%"))
    if pomFile == ""
        return
    endif

    let combined_args = " " . a:args . " " . g:maven_args

    " Execute Maven in console
    if a:bang == "!"
        execute "silent !mvn -f " . pomFile . combined_args

        if v:shell_error == 0
            call s:EchoMessage("Execute '!mvn " . combined_args .  "' successfully.")
        else
            call s:EchoWarning("Executing '!mvn " . combined_args .  "' is failed. Exit Code: " . v:shell_error)
        endif

        redraw!
        return
    endif
    " //:~)

    let old_makeprg = &l:makeprg
    let old_errorformat = &l:errorformat
    let old_shellpipe = &shellpipe
    let old_shell = &shell
    compiler maven

    " Execute Maven by compiler framework in VIM
    execute "silent make! -f " . pomFile . combined_args
    redraw!

    let &l:makeprg = old_makeprg
    let &l:errorformat = old_errorformat
    let &shellpipe=old_shellpipe
    let &shell=old_shell

    " Open cwindow if the shell has error or the list of quickfix has 'Error' or 'Warning'.
    " Otherwise, close the quickfix window
    if v:shell_error != 0
        call s:OpenQuickfixWindowAndJump()
        return
    endif

    for qfentry in getqflist()
        if qfentry.type =~ '^[EW]$'
            call s:OpenQuickfixWindowAndJump()
            return
        endif
    endfor
    call s:EchoMessage("Execute 'mvn " . combined_args .  "' successfully.")
    " //:~)
endfunction
function! <SID>OpenQuickfixWindowAndJump()
    copen
endfunction
function! <SID>GetPOMXMLFile(buf)
    if !s:CheckFileInMavenProject(a:buf)
        return
    endif

    return maven#getMavenProjectRoot(a:buf) . "/pom.xml"
endfunction

" Because the path in message output by Maven has '/<fullpath>' in windows
" system, this function would adapt the path for correct path of jump voer
" quickfix
function! <SID>ProcessQuickFixForMaven()
    let qflist = getqflist()

    for qfentry in qflist
        " Get the file comes from VIM's quickfix
        if has_key(qfentry, "filename")
            let filename = qfentry.filename
        elseif qfentry.bufnr > 0
            let filename = bufname(qfentry.bufnr)
        else
            let filename = ""
        endif
        " //:~)

        " ==================================================
        " Process the file name for:
        " 1. Fix wrong file name in Windows system
        " 2. Convert class name to file name for unit test
        " ==================================================
        if filename =~ '\v^\w+%(\.\w+)*\.\u\k+$' " The file name matches the pattern of full class name of Java
            call s:AdaptFilenameOfUnitTest(qfentry, filename)
        elseif qfentry.type =~ '^[EW]$' && filename =~ '\v^\f+$' " The file name matches valid file format under OS
            call s:AdaptFilenameOfError(qfentry, filename)
        endif
        " //:~)
    endfor

    call setqflist(qflist, 'r')
endfunction

function! <SID>AdaptFilenameOfError(qfentry, rawFileName)
    let rawFileName = a:rawFileName

    " ==================================================
    " Fix the /C:/source.code path generated by maven-compiler-plugin 3.0
    " ==================================================
    if has("win32") && rawFileName =~ '\v^/[a-zA-Z]:/'
        let a:qfentry.filename = substitute(rawFileName, '^/', '', '')
        unlet a:qfentry.bufnr
    endif
    " //:~)
endfunction

function! <SID>AdaptFilenameOfUnitTest(qfentry, fullClassName)
    " Convert the full name of class to full path of file
    let filename = substitute(a:fullClassName, '\.', '/', 'g')
    let listOfTestFiles = split(glob(maven#getMavenProjectRoot(bufnr("%")) . '/src/test/**/' . filename . ".*"), "\n")

    if len(listOfTestFiles) == 0
        let a:qfentry.filename "<Can't Find File for " . a:fullClassName . ">"
    else
        let a:qfentry.filename = listOfTestFiles[0]
    endif
    unlet a:qfentry.bufnr
    " //:~)

    " Adjust the search string
    let a:qfentry.pattern = substitute(a:qfentry.pattern, '^\^\\V', '', '') " Remove the heading '^\V'
    let a:qfentry.pattern = substitute(a:qfentry.pattern, '\\\$$', '', '') " Remove the tailing '\$'
    let a:qfentry.pattern = '\<' . a:qfentry.pattern . '\>' " Add wrap of a word
    " //:~)

    let a:qfentry.type = "E"
endfunction

function! <SID>CompleteMavenLifecycle(argLead, cmdLine, cursorPos)
    return join(['preclean', 'clean', 'postclean',
        \ 'validate', 'initialize',
        \ 'generate-sources', 'process-sources', 'generate-resources', 'process-resources', 'compile', 'process-classes',
        \ 'generate-test-sources', 'process-test-sources', 'generate-test-resources', 'process-test-resources',
        \ 'test-compile', 'process-test-classes', 'post-process', 'test',
        \ 'prepare-package', 'package',
        \ 'pre-integration-test', 'integration-test', 'post-integration-test',
        \ 'verify', 'install', 'deploy',
        \ 'pre-site', 'site', 'post-site', 'site-deploy'
    \ ], "\n")
endfunction
"}}}

" Auto change the buffer's directory to POM location{{{1
function! <SID>AutoChangeCurrentDirOfWindow()
    if g:maven_auto_chdir == 0
        return
    endif

    let currentBuffer = bufnr("%")

    if !maven#isBufferUnderMavenProject(currentBuffer)
        return
    endif

    execute "lcd " . maven#getMavenProjectRoot(currentBuffer)
endfunction
"}}}

" Utility {{{1
function! <SID>CheckFileInMavenProject(buf)
    if !maven#isBufferUnderMavenProject(a:buf)
        call s:EchoWarning("File doesn't exist in Maven project")
        return 0
    endif

    return 1
endfunction

function! <SID>EchoMessage(msg)
    echohl MoreMsg
    echomsg a:msg
    echohl None
endfunction
function! <SID>EchoWarning(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction

" }}}
