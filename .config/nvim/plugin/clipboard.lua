if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
		},
		cache_enabled = 0,
	}


-- TODO: Only fallback to osc52 if we are running in docker
elseif vim.fn.executable("wl-copy") == 0 or vim.fn.executable("wl-paste") == 0 then
	vim.g.clipboard = "osc52"
end

