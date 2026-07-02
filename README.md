# Neovim Configuration

A complete Neovim config built from scratch, prioritizing **LSP + autocomplete** for all languages, **LazyVim-compatible keybindings**, and **sidekick.nvim** for agentic coding with OpenCode.

## Supported Languages

| Language | LSP Server | Formatter | Linter | Notes |
|----------|-----------|-----------|--------|-------|
| **C/C++/CUDA** | `clangd` | `clang-format` | clangd built-in | Handles `.cu`/`.cuh` natively. Needs `compile_commands.json` for project indexing |
| **JavaScript** | `ts_ls` | `prettier` | `eslint_d` | — |
| **TypeScript** | `ts_ls` | `prettier` | `eslint_d` | — |
| **JSX/TSX** | `ts_ls` | `prettier` | `eslint_d` | ts_ls handles JSX/TSX natively |
| **CSS** | `cssls` | `prettier` | — | — |
| **HTML** | `html` | `prettier` | — | — |
| **Python** | `pyright` | `black` | `ruff` | — |
| **Dockerfile** | `dockerls` | — | — | Needs Docker installed for contextual help |
| **Docker Compose** | `docker_compose_language_service` | — | — | — |
| **Markdown** | `marksman` | `prettier` | `markdownlint` | — |
| **YAML** | `yamlls` | `prettier` | — | — |
| **SQL** | `sqls` | `sql-formatter` | — | — |
| **Bash** | `bashls` | `shfmt` | `shellcheck` | shellcheck installed via apt |
| **Lua** | `lua_ls` | `stylua` | — | For editing your nvim config |

> **Note:** Mason auto-installs all LSP servers, formatters, and linters on first launch. You only need the system dependencies below.

---

## Setup Guide (Ubuntu 26.04)

### 1. Upgrade Neovim to 0.12+

Ubuntu ships Neovim 0.11 by default. To get 0.12+:

```bash
# Option A: Snap (easiest, auto-updates)
sudo snap install nvim --edge

# Option B: AppImage (manual, portable)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# Option C: Build from source
sudo apt install ninja-build gettext cmake unzip curl build-essential
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

Verify: `nvim --version` should show `v0.12.x`

### 2. Install mise (version manager for Node.js, Python, etc.)

```bash
# Install mise
curl https://mise.run | sh

# Activate in your shell (add to ~/.bashrc or ~/.zshrc)
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
# For zsh users:
# echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

### 3. Install Node.js & Python via mise

```bash
# Install and set global versions
mise use --global node@lts      # Node 22 LTS (needed by many LSP servers)
mise use --global python@3.13   # Python 3.13

# Verify
node --version    # Should show v22.x
python --version  # Should show 3.13.x
```

### 4. Core System Dependencies

```bash
sudo apt update
sudo apt install -y \
  git \
  curl \
  tar \
  unzip \
  build-essential \
  ripgrep \
  fd-find \
  shellcheck \
  luarocks
```

> **Note:** On Ubuntu, `fd` is installed as `fd-find` and the binary is `fdfind`. Create a symlink:
> ```bash
> sudo ln -sf $(which fdfind) /usr/local/bin/fd
> ```

### 5. tree-sitter CLI (required by nvim-treesitter main branch)

```bash
# Via mise-managed npm (simplest since Node is already installed)
npm install -g tree-sitter-cli

# Or download binary directly:
curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
gunzip tree-sitter-linux-x64.gz
chmod +x tree-sitter-linux-x64
sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter
```

### 6. Python Tools

```bash
pip install black ruff
```

### 7. OpenCode CLI (for sidekick.nvim)

```bash
# Install opencode — check https://github.com/opencode-ai/opencode for latest
curl -fsSL https://opencode.ai/install.sh | bash
# Or via go install:
go install github.com/opencode-ai/opencode@latest
```

### 8. tmux (for sidekick.nvim persistent sessions)

```bash
sudo apt install -y tmux
```

### 9. Deploy the config

```bash
# Back up existing config if any
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Symlink this repo (recommended — keeps it version-controlled)
ln -sf /path/to/this/repo ~/.config/nvim

# Or copy:
# cp -r /path/to/this/repo/* ~/.config/nvim/
```

### 10. First launch

```bash
nvim
```

On first launch:
1. **lazy.nvim** will auto-install all plugins (~30 seconds)
2. **Mason** will auto-install all 13 LSP servers + formatters + linters
3. **Treesitter** will compile 25+ language parsers

Run `:checkhealth` after first launch to verify everything is working.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                        # Entry point — bootstraps lazy.nvim, mise PATH
├── lua/
│   ├── config/
│   │   ├── options.lua             # Vim options (tabs, numbers, clipboard, etc.)
│   │   ├── keymaps.lua             # LazyVim-compatible keymaps
│   │   └── autocmds.lua            # Auto-commands (CUDA detection, etc.)
│   └── plugins/
│       ├── colorscheme.lua         # Catppuccin Mocha theme
│       ├── lsp.lua                 # LSP + Mason + 13 language servers
│       ├── completion.lua          # blink.cmp autocomplete
│       ├── treesitter.lua          # Syntax highlighting + textobjects
│       ├── telescope.lua           # Fuzzy finder
│       ├── formatting.lua          # conform.nvim (prettier, black, etc.)
│       ├── linting.lua             # nvim-lint (eslint, ruff, etc.)
│       ├── editor.lua              # pairs, surround, comments, TODO, trouble
│       ├── ui.lua                  # lualine, bufferline, which-key, noice
│       ├── neo-tree.lua            # File explorer
│       ├── gitsigns.lua            # Git integration
│       └── sidekick.lua            # sidekick.nvim + OpenCode AI
└── lazy-lock.json                  # Auto-generated lockfile
```

---

## Keymap Cheat Sheet

Leader key is `<Space>`.

### LSP (active when a language server is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to Definition |
| `gr` | Find References |
| `gI` | Go to Implementation |
| `gy` | Go to Type Definition |
| `gD` | Go to Declaration |
| `K` | Hover Documentation |
| `gK` | Signature Help |
| `<leader>ca` | Code Action |
| `<leader>cr` | Rename Symbol |
| `<leader>cl` | LSP Info |
| `<leader>cf` | Format document |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev error |

### Files & Search

| Key | Action |
|-----|--------|
| `<leader><space>` | Find files |
| `<leader>ff` | Find files |
| `<leader>/` | Grep in project |
| `<leader>fr` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fg` | Git files |
| `<leader>sg` | Grep |
| `<leader>sw` | Grep word under cursor |
| `<leader>sk` | Search keymaps |
| `<leader>sh` | Search help |

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>-` | Horizontal split |
| `<leader>\|` | Vertical split |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree |
| `<leader>E` | Reveal current file |

### Git

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghb` | Blame line |
| `<leader>ghd` | Diff this |
| `<leader>gc` | Git commits (Telescope) |
| `<leader>gs` | Git status (Telescope) |

### AI (Sidekick / OpenCode)

| Key | Action |
|-----|--------|
| `<leader>aa` | Toggle Sidekick CLI |
| `<leader>ac` | Send context to CLI |
| `<leader>ad` | Review AI diff |
| `<leader>aA` | Accept all AI changes |
| `<Tab>` (insert) | Accept Next Edit Suggestion |

### General

| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `<leader>qq` | Quit all |
| `<leader>l` | Open Lazy plugin manager |
| `<A-j>` / `<A-k>` | Move line down/up |
| `gc` | Toggle comment |
| `gsa` / `gsd` / `gsr` | Surround add/delete/replace |

---

## Troubleshooting

- **LSP not attaching?** Run `:LspInfo` in a buffer to check. Run `:Mason` to verify servers are installed.
- **Treesitter errors?** Make sure `tree-sitter` CLI is installed and on PATH. Run `:TSUpdate` to recompile parsers.
- **Mason can't find node/python?** The config adds `~/.local/share/mise/shims` to PATH in `init.lua`. Make sure mise is set up correctly.
- **Format on save not working?** Run `:ConformInfo` to check which formatter is configured for the current filetype.
- **Sidekick not connecting?** Run nvim inside a `tmux` session. Verify `opencode` is on your PATH.
