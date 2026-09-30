return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = function()
    return {
      keymap = {
        preset = 'default',

        ['<C-L>'] = { 'select_and_accept' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-d>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      signature = { enabled = true },

      appearance = { nerd_font_variant = 'mono' },

      completion = {
        documentation = { auto_show = true },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          path = {
            opts = {
              -- Pi edits /tmp/pi-editor-*/prompt.md, but Neovim inherits Pi's cwd.
              -- Complete paths from project cwd instead of temporary buffer directory.
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" }
    }
  end,
}
