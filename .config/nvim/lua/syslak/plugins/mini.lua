return {
    {
        'echasnovski/mini.pairs', version = '*',
        config = function()
            require("mini.pairs").setup()
        end
    },
    {
        'echasnovski/mini.comment', version = '*',
        config = function()
            require("mini.comment").setup()
         
        end
    },
    {
        'echasnovski/mini.surround', version = '*',
        config = function()
            require("mini.surround").setup()
         
        end
    },
    { 'echasnovski/mini.bufremove', version = '*' },
    -- version = '*',
    -- config = function()
    --     require("mini.pairs").setup()
    --     require("mini.comment").setup()
    -- end
}

