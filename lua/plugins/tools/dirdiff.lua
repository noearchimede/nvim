return {

    "will133/vim-dirdiff",

    cmd = "DirDiff",

    init = function()

        vim.g.DirDiffNextKeyMap = '<localleader>n'
        vim.g.DirDiffPrevKeyMap = '<localleader>p'

        vim.g.DirDiffGetKeyMap = '<localleader>g'
        vim.g.DirDiffPutKeyMap = '<localleader>p'


        -- Ignore FileName case during diff:
        vim.g.DirDiffIgnoreFileNameCase = 0
        -- Sets default exclude pattern:
        vim.g.DirDiffExcludes = '' -- default: "CVS,*.class,*.exe,.*.swp"
        -- Sets default ignore pattern:
        vim.g.DirDiffIgnore = ''-- default: "Id:,Revision:,Date:"
        -- If DirDiffSort is set to 1, sorts the diff lines:
        vim.g.DirDiffSort = 1
        -- Sets the diff window (bottom window) height (rows):
        vim.g.DirDiffWindowSize = 14
        -- Ignore case during diff:
        vim.g.DirDiffIgnoreCase = 0
        -- To specify a valid theme (e.g. github):
        vim.g.DirDiffTheme = "github"
        -- To use [ and ] rather than [c and ]c motions:
        vim.g.DirDiffSimpleMap = 0
        -- Add extra options to the "diff" tool. For example, use "-w" to ignore white
        -- spaces or "-N" to list all new files even when inside a new folder (instead of
        -- just listing the new folder name)
        vim.g.DirDiffAddArgs = "-w"

    end

}
