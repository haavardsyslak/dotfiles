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

        ['<C-j>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-k>'] = { 'select_next', 'fallback_to_mappings' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-d>'] = { 'show_signature', 'hide_signature', 'fallback' },

        -- Manual AI completion via Ollama (battery-friendly: no auto-trigger)
        -- ['<A-y>'] = require('minuet').make_blink_map(),
      },

      signature = { enabled = true },

      appearance = { nerd_font_variant = 'mono' },

      completion = {
        documentation = { auto_show = true },
        -- Don't warm up minuet on every InsertEnter; fire only on <A-y>
        trigger = { prefetch_on_insert = false },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" }
    }
  end,
  opts_extend = { "sources.default" }
}
