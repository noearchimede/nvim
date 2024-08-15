return {

    'altermo/ultimate-autopair.nvim',

    branch = 'v0.6', --recommended as each new version will have breaking changes

    event = { 'InsertEnter' },

    keys = {
        {
            "<leader>xp",
            function()
                require('ultimate-autopair').toggle()
                if require('ultimate-autopair').isenabled() then
                    print("Autopair enabled")
                else
                    print("Autopair disabled")
                end
            end,
            desc = "Autopair: toggle"
        }
    },

    opts = {
        profile = 'default', --what profile to use

        map = true, --whether to allow any insert map
        cmap = false, --cmap stands for cmd-line map whether to allow any cmd-line map

        pair_map = true, --whether to allow pair insert map
        pair_cmap = false, --whether to allow pair cmd-line map

        multiline = true, --enable/disable multiline

        bs = {
            enable = true,
            map = '<bs>', --string or table
            overjumps = true, --(|foo) > bs > |foo
            space = true, --false, true or 'balance' ( |foo ) > bs > (|foo); balance Will prioritize balanced spaces ( |foo  ) > bs > ( |foo )
            indent_ignore = false, --(\n\t|\n) > bs > (|)
            single_delete = false, -- <!--|--> > bs > <!-|
        },

        cr = {
            enable = true,
            map = '<cr>', --string or table
            autoclose = false, --(| > cr > (\n|\n)
        },

        space = {
            enable = true,
            map = ' ', --string or table
            check_box_ft = { 'markdown', 'vimwiki', 'org' },
        },

        fastwarp = {
            enable = true,
            enable_normal = true,
            enable_reverse = true,
            hopout = false, --{(|)} > fastwarp > {(}|)
            map = '<C-k>', --string or table
            rmap = '<C-h>', --string or table
            multiline = true, --(|) > fastwarp > (\n|)
            nocursormove = true, --makes the cursor not move (|)foo > fastwarp > (|foo); disables multiline feature
            do_nothing_if_fail = true, --add a module so that if fastwarp fails then an `e` will not be inserted
            no_filter_nodes = {
                'string',
                'raw_string',
                'string_literals',
                'character_literal',
            }, --which nodes to skip for tsnode filtering
            faster = true, --only enables jump over pair, goto end/next line useful for the situation of: {|}M.foo('bar') > {M.foo('bar')|}
        },

        close = {
            enable = false,
            map = '<A-]>', --string or table
        },

        extensions = {
            cond = {
                cond = function(fn)
                    -- disable in comments, while registering macros and in replace mode
                    return not fn.in_node('comment') and not fn.in_macro() and not fn.get_mode()~='R'
                end,
            },
        },

        tabout = {
            enable = false,
            map = '<A-tab>',
        },
    },

}
