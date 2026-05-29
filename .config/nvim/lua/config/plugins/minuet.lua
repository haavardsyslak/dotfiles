return {
  'milanglacier/minuet-ai.nvim',
  enabled = false,
  config = function()
    require('minuet').setup({
      provider = 'gemini',
      n_completions = 1,
      context_window = 512,
      request_timeout = 60,
      throttle = 3000,
      debounce = 800,
      provider_options = {
        gemini = {
          api_key = 'GEMINI_API_KEY',
          model = 'gemini-2.5-flash',
          optional = {
            generationConfig = {
              maxOutputTokens = 64,
              topP = 0.9,
            },
          },
        },
      },
    })
  end,
}
