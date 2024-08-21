return {

    "lervag/vimtex",

    lazy = false, -- do not lazy load. Vimtex mostly lazy-loads itself, and lazy-loading it entirely breaks some features (see readme)

    init = function()

        -- use skim as viewer
        vim.g.vimtex_view_method = 'skim'

        -- use '<localleader>' as prefix for plugin mappings (default is '<localleader>l')
        vim.g.vimtex_mappings_prefix = '<localleader>'

        -- Latexmk variables: save output files in 'build' directory, disable continuous compilation
        vim.g.vimtex_compiler_latexmk = { build_dir = 'build', continuous = 0 }
    end

}
