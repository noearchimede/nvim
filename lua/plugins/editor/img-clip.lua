return {

    "HakonHarnes/img-clip.nvim",

    event = "VeryLazy",

    keys = {
        { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },

    opts = {

        default = {
            -- prompt options
            prompt_for_file_name = true,
            show_dir_path_in_prompt = true,
        },

        filetypes = {

            markdown = {
                template = function(context)
                    -- the label is just a placeholder that is meant to be replaced in most cases. Use the filename
                    -- without dashes (filename is defined below) and place the cursor on the first letter in normal
                    -- mode so that it can be overwritten with a single 'caw' command
                    local label = context.file_name_no_ext:gsub("-", "")
                    return "![" .. label:sub(1,1) .. context.cursor .. label:sub(2) .. "](" .. context.file_path:gsub(" ", "%%20") .. ")"
                end,
                url_encode_path = false, -- appears to print %% instead of single %
                insert_mode_after_paste = false,

                download_images = true,
                copy_images = true,

                prompt_for_file_name = false,
                file_name = "%Y-%m-%d-%H%M%S",
                use_absolute_path = false,
                relative_to_current_file = true,
                dir_path = function()
                    -- dir path: filename.assets
                    return vim.fn.expand("%:t:r") .. ".assets"
                end,
            },

        },

    },

}
