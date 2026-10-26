-- ============================================================================
-- Minimal Neovim config (Neovim 0.12+)
-- Plugins: telescope, neogit, copilot.vim, lspconfig+mason, catppuccin
-- Managed with the built-in `vim.pack` plugin manager (no lazy.nvim)
-- ============================================================================

-- Leader key: <space> (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---------------------------------------------------------------------------
-- Options
-- ---------------------------------------------------------------------------
vim.opt.number = true             -- absolute line numbers
vim.opt.expandtab = true          -- spaces instead of tabs
vim.opt.shiftwidth = 4            -- indent size
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.ignorecase = true         -- case-insensitive search...
vim.opt.smartcase = true          -- ...unless you type capitals
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true      -- needed for catppuccin
vim.opt.clipboard = "unnamedplus" -- share clipboard with Windows
vim.opt.updatetime = 250
-- Show the completion menu but never auto-insert / pre-select the first item
vim.opt.completeopt = { "menu", "menuone", "popup", "noinsert", "noselect" }
-- Keep Copilot ghost text visible even while the LSP completion menu is open
vim.g.copilot_hide_during_completion = 0

-- ---------------------------------------------------------------------------
-- Auto-reload files changed on disk
-- ---------------------------------------------------------------------------
-- 'autoread' alone only helps when Neovim checks the file; add idle/focus
-- events so external edits show up without reopening the buffer.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() !=# 'c' | checktime | endif",
})

-- ---------------------------------------------------------------------------
-- Plugins (vim.pack, built into Neovim 0.12+)
-- ---------------------------------------------------------------------------
-- Installed under stdpath("data")/site/pack/core/opt; pinned in
-- nvim-pack-lock.json (next to this file, safe to commit).
-- Update with `:PackUpdate` or `:lua vim.pack.update()`.
-- Order matters for load order: dependencies first.
vim.pack.add({
  -- Theme: catppuccin
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Telescope: fuzzy finder (+ plenary dependency)
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x" },

  -- Neogit: Magit-style git interface
  { src = "https://github.com/NeogitOrg/neogit" },

  -- GitHub Copilot (official plugin)
  { src = "https://github.com/github/copilot.vim", version = "release" },

  -- LSP: default server configs + Mason (auto-install servers)
  -- tsc = TypeScript 7 native (Go) language server; `tsc --lsp`
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

-- Theme
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd.colorscheme("catppuccin")

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.git_status, { desc = "Files with git changes" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Search in files" })

-- Neogit (loaded eagerly now; vim.pack has no declarative lazy-loading)
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "jsonls", "tsc" } })

-- Update helper (replaces `:Lazy update`)
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update plugins (vim.pack)" })

-- ---------------------------------------------------------------------------
-- LSP setup
-- ---------------------------------------------------------------------------
-- lua_ls: don't warn about the global `vim`
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- gdscript: no install needed — connects to the language server that the
-- Godot editor runs on 127.0.0.1:6005 (editor must be open with your project)
vim.lsp.enable("gdscript")
-- lua_ls, jsonls and tsc are enabled automatically by mason-lspconfig

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Built-in autocompletion (no extra plugin needed)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    -- gd is not a default mapping; grn/grr/gra/gri/K are built-in defaults
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
  end,
})

-- ---------------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------------
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-h>", "<C-w>h") -- move between splits with Ctrl+hjkl
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
