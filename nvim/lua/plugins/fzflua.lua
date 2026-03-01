return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys={
        { 
            "<leader>ff",
            function() require('fzf-lua').files() end,
            desc="Find Files in the project directory",
        },
        {
            "<leader>fg",
            function() require('fzf-lua').live_grep() end,
            desc="Find by grepping in the project directory",
        },
        {
            "<leader>fh",
            function() require('fzf-lua').helptags() end,
            desc = "Find in the neovim help",
        },
        {
            "<leader>fk",
            function() require('fzf-lua').keymaps() end,
            desc = "Find in the nvim keymaps",
        },
        {
            "<leader>fb",
            function() require('fzf-lua').builtin() end,
            desc = "Find Built in Fuzzy Finders",
        },
        {
            "<leader>fw",
            function() require('fzf-lua').grep_cword() end,
            desc = "Find Current Word",
        },
        {
            "<leader>fW",
            function() require('fzf-lua').grep_cWORD() end,
            desc = "Find Current WORD"
        },
        {
            "<leader>fd",
            function() require('fzf-lua').diagnostics_document() end,
            desc = "Find Diagnostics"
        },
        {
            "<leader>fr",
            function() require('fzf-lua').resume() end,
            desc = "Find Resume"
        },
        {
            "<leader>fo",
            function() require('fzf-lua').buffers() end,
            desc = "Find old files in the Buffer"
        },
        {
            "<leader><leader>",
            function() require('fzf-lua').buffers() end,
            desc = "find existing buffers"
        },
        {
            "<leader>/",
            function() require('fzf-lua').lgrep_curbuf() end,
            desc = "Live grep the current buffer"
        }
    }
}
