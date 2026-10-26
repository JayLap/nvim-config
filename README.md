# nvim-config

My Neovim configuration. Source of truth lives here; the live config is synced
by hand into Neovim's config directory on each machine.

## Files

| File                  | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| `init.lua`            | The whole config (options, plugins, LSP, keymaps).  |
| `nvim-pack-lock.json` | Pinned plugin versions (`vim.pack`). Commit this.   |

Plugins themselves are installed by `vim.pack` under `stdpath("data")`, **not**
in this repo, so there is nothing else to track.

## Config directory per OS

Neovim reads `init.lua` from:

- Windows: `%LOCALAPPDATA%\nvim`  (i.e. `~/AppData/Local/nvim`)
- Linux/macOS: `~/.config/nvim`

## Sync (manual)

Copy the two files from this repo into the config directory.

From this repo, on Windows:

```bash
cp init.lua nvim-pack-lock.json ~/AppData/Local/nvim/
```

After editing the live config and wanting to save it back here:

```bash
cp ~/AppData/Local/nvim/init.lua ~/AppData/Local/nvim/nvim-pack-lock.json .
```

## New machine setup

1. Requires **Neovim 0.12+** (this config uses `vim.pack`).
2. Install Neovim, then clone this repo somewhere and copy the files into the
   config directory (see above).
3. Launch `nvim`. `vim.pack` will prompt to install the plugins.
4. Run `:Mason` to install the LSP servers (`lua_ls`, `jsonls`, `tsc`).
5. Run `:Copilot setup` to authenticate Copilot. Credentials are stored
   outside this repo and are per-machine.

## Updating plugins

`:PackUpdate` updates plugins and rewrites `nvim-pack-lock.json`. Copy the
updated lock file back into this repo and commit it.
