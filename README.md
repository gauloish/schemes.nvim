# schemes.nvim

A simple plugin to manage colorschemes.

## Requirements

- [Neovim (v0.9.5)](https://github.com/neovim/neovim/releases/tag/v0.9.5) (or latest)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

You can install `schemes.nvim` with any plugin manager, from `gauloish/schemes.nvim`. Just make sure you have `telescope.nvim` installed.

## Setup

You can use the `setup()` function to configure the plugin:

```lua
require("schemes").setup({
    before = function(scheme)
        -- Function to be called before change colorscheme
        -- `scheme` is the current scheme
    end,
    after = function(scheme)
        -- Function to be called after change colorscheme
        -- `scheme` is the new current scheme
    end,
    default = {
        name = "...", -- a string with default colorscheme name, it must be installed
        background = "dark" | "light", -- a string background of default colorscheme, it must be "dark" or "light"
        command = function()
            -- Function called to change colorscheme to default
        end,
    },
    schemes = {
        -- List of schemes like `default`
        -- Make sure that two schemes does not have the same `name` and `background` fields
    }
})
```

Each `scheme` in `schemes` table must be like the `default` colorscheme:

```lua
scheme = {
    name = "...", -- a string with colorscheme name
    background = "dark" | "light", -- a string background of default colorscheme, it must be "dark" or "light"
    command = function()
        -- Function called to change colorscheme
    end,
}
```

The only required fields in schemes are `name`, `background` and `command`, then you can put other fields like color palettes or functions to be called in `before()` and `after()` functions.

## Usage

The command `:Schemes` open a `telescope` picker with the schemes passed in `setup()` function. You can set a keymap for this command:

Using VimL:

```viml
" Keymap in VimL to call :Schemes command
nnoremap <leader>fs <cmd>Schemes<cr>
```

Using Lua:

```lua
-- Keymap in Lua to call :Schemes command
vim.keymap.set("n", "<leader>fs", ":Schemes", { silent = true, desc = "Telescope picker for colorschemes" })
```
