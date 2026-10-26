return {

    enabled = false,
    "SUSTech-data/neopyter",

    dependencies = {
        'AbaoFromCUG/websocket.nvim', -- for mode='direct'
    },

    config = function()


        -- File handling in this config --
        --
        -- <name>.ju.py       --> script that will be kept in storage (.py may be replaced by any other compatible format)
        -- %<name>.temp.ipynb --> TEMPORARY jupyter notebook managed by neopyter
        --
        -- The notebook file will be deleted when the buffer is closed, as long as the name has not been changed. To
        -- keep a notebook with all outputs use the "File -> Download" menu in Jupyter Lab.
        --

        -- create absolute ipynb path based on the absolute .ju.xx path
        local function build_ipynb_path(script_path)
            local dir = vim.fs.dirname(vim.fs.abspath(script_path))
            local tail = vim.fn.fnamemodify(script_path, ":t:r:r") -- :t:r:r means basename minus two dot-separated extensions
            local abspath = vim.fs.normalize(dir .. "/" .. "%" .. tail .. ".temp.ipynb") -- add leading % and custom extension
            return abspath
        end

        -- Jupyter interprets all paths relative to its root. This function convers an absolute path in one relative to
        -- the jupyter root, allowing to match scripts and notebooks regardless of the nvim working directory and
        -- jupyter root.
        local function convert_to_jupyter_path(abspath)
            -- use the Jupyter CLI to extract its root directory
            local jsonlist = vim.system({ "jupyter", "server", "list", "--jsonlist" }, { text = true }):wait().stdout
            -- get first server in list. The behaviour of my neopyter config is not defined for multiple running jupyter instances.
            local server = vim.json.decode(jsonlist or '{}')[1]
            local jupyter_root = vim.fs.normalize(server.root_dir)
            -- jupyter_root is nil if root_dir is not found in the decoded json string
            if not jupyter_root then
                vim.notify("ERROR: unable to get Jupyter server root")
                return nil
            end
            -- if the jupyter root is not in the normalized abspath jupyter won't be able to open the correct notebook
            if not vim.startswith(abspath, jupyter_root .. "/") then
                vim.notify("ERROR: the Jupyter server root does not contain the target directory")
                return nil
            end
            -- subtract the jupyter root from the absolute path to get a jupyter-relative path
            local jupyter_rel_path = abspath:sub(#jupyter_root + 2)
            return jupyter_rel_path
        end

        require('neopyter').setup({

            mode = "direct",

            remote_address = "127.0.0.1:9001",

            auto_connect = false,
            auto_attach = false,

            parser = {
                trim_whitespace = true,
            },

            file_pattern = { "*.ju.*" },
            filename_mapper = function(ju_path)
                local ipynb_abspath = build_ipynb_path(ju_path)
                local jupyter_relpath = convert_to_jupyter_path(ipynb_abspath)
                return jupyter_relpath or ''
            end,

            on_attach = function(bufnr)
                -- do some buffer keymap

                -- this autocmd attempts to delete the %<name>.temp.ipynb file associated with a buffer when it is closed
                vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
                    buffer = bufnr,
                    callback = function(args)
                        require("neopyter.async").run(function()
                            local current_notebook = require("neopyter.jupyter").notebook
                            current_notebook:open_or_reveal()
                            current_notebook:activate()
                            current_notebook:run_selected_cell()
                            -- jupyter.jupyterlab:execute_command("application:close") -- close current tab
                        end)
                        local bufname = vim.api.nvim_buf_get_name(args.buf)
                        -- local ok, _ = os.remove(build_ipynb_path(bufname))
                        if 1 then
                            vim.notify("Neopyter: deleted temporary notebook " .. bufname)
                        end
                    end,
                })

            end,
        })
    end,

}
