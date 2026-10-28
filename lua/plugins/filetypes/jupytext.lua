return {

    "goerz/jupytext.nvim",

    cmd = {"Jupytext"},

    opts = {
        format = 'py:percent',
        update = true, -- preserve cell outputs in the .ipynb file on save
    },

}
