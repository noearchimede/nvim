return {
    cmd = {
        "clangd",
        -- use the WebKit format if there is no .clangd-format file in the project root
        "--fallback-style=WebKit",
    },
    root_markers = { '.clangd', 'compile_commands.json' },
    filetypes = { 'c', 'cpp' }
}
