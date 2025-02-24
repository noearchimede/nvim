return {

    'tris203/precognition.nvim',

    cmd = { 'Prec' },

    config = {
        vim.api.nvim_create_user_command("Prec", function() require('precognition').toggle() end, {})
    }
}
