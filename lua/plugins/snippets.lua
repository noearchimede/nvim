-- Snippets
--
-- Snippets are provided by UltiSnips


return {
    -- ultisnips
    {
        "Sirver/ultisnips",
        event = { "InsertEnter" }
    },
    -- integration with nvim-cmp
    {
        "quangnguyen30192/cmp-nvim-ultisnips"
    },
}

-- NOTE: the keybindings for UltiSnips are defined in the configuration for
-- nvim-cmp, as the same keys are used to navigate the completion menu
