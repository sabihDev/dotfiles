-- NvChad-inspired native statusline (Neovim 0.12+)
-- Minimal, fast, modular, plugin-free

local M = {}

---------------------------------------------------------------------
-- Icons (keep minimal, NvChad-like)
---------------------------------------------------------------------
local icons = {
	branch = "",
	lsp = "󰒋",
	error = "",
	warn = "",
	modified = "●",
	readonly = "",
}

---------------------------------------------------------------------
-- Palette (NvChad-style dark UI)
---------------------------------------------------------------------
local C = {
	bg = "#1e1e2e",
	text = "#cdd6f4",

	blue = "#89b4fa",
	green = "#a6e3a1",
	yellow = "#f9e2af",
	red = "#f38ba8",
	mauve = "#cba6f7",

	muted = "#6c7086",
}

---------------------------------------------------------------------
-- Mode mapping
---------------------------------------------------------------------
local modes = {
	n = { "NORMAL", C.blue },
	i = { "INSERT", C.green },
	v = { "VISUAL", C.mauve },
	V = { "V-LINE", C.mauve },
	["\22"] = { "V-BLOCK", C.mauve },
	c = { "COMMAND", C.yellow },
	R = { "REPLACE", C.red },
	t = { "TERMINAL", C.green },
}

---------------------------------------------------------------------
-- Highlights
---------------------------------------------------------------------
local function hl(name, opts)
	vim.api.nvim_set_hl(0, name, opts)
end

local function set_highlights(mode_color)
	hl("SL_Mode", { fg = C.bg, bg = mode_color, bold = true })
	hl("SL_File", { fg = C.text, bg = C.bg })
	hl("SL_Git", { fg = C.muted, bg = C.bg })
	hl("SL_DiagErr", { fg = C.red, bg = C.bg })
	hl("SL_DiagWarn", { fg = C.yellow, bg = C.bg })
	hl("SL_Lsp", { fg = C.muted, bg = C.bg })
	hl("SL_Pos", { fg = C.text, bg = C.bg, bold = true })
end

---------------------------------------------------------------------
-- Mode
---------------------------------------------------------------------
local function get_mode()
	local m = vim.api.nvim_get_mode().mode
	local data = modes[m] or { m:upper(), C.blue }

	set_highlights(data[2])

	return data[1]
end

local function mode_component()
	return "%#SL_Mode# " .. get_mode() .. " "
end

---------------------------------------------------------------------
-- Git (cached system call for performance)
---------------------------------------------------------------------
local git_cache = { path = "", branch = "" }

local function get_git_branch()
	local filepath = vim.fn.expand("%:p:h")
	if filepath == "" then return "" end

	if git_cache.path == filepath then
		return git_cache.branch
	end

	local branch = vim.fn.system(
		"git -C " .. vim.fn.shellescape(filepath) ..
		" rev-parse --abbrev-ref HEAD 2>/dev/null"
	):gsub("\n", "")

	if branch == "" or branch:find("fatal") then
		branch = ""
	end

	git_cache = { path = filepath, branch = branch }
	return branch
end

local function git_component()
	local branch = get_git_branch()
	if branch == "" then return "" end
	return "%#SL_Git# " .. icons.branch .. " " .. branch .. " "
end

---------------------------------------------------------------------
-- File
---------------------------------------------------------------------
local function file_component()
	local name = vim.fn.expand("%:t")
	if name == "" then name = "[No Name]" end

	if vim.bo.modified then
		name = name .. " " .. icons.modified
	end

	if vim.bo.readonly then
		name = name .. " " .. icons.readonly
	end

	return "%#SL_File# " .. name .. " "
end

---------------------------------------------------------------------
-- Diagnostics (fast + minimal)
---------------------------------------------------------------------
local function diagnostics_component()
	local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	local out = ""
	if e > 0 then
		out = out .. icons.error .. e .. " "
	end
	if w > 0 then
		out = out .. icons.warn .. w
	end

	if out == "" then return "" end

	return "%#SL_DiagErr# " .. out .. " "
end

---------------------------------------------------------------------
-- LSP (robust client getter)
---------------------------------------------------------------------
local function lsp_component()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then return "" end

	local names = {}
	for _, c in ipairs(clients) do
		names[#names + 1] = c.name
	end

	return "%#SL_Lsp# " .. icons.lsp .. " " .. table.concat(names, ", ") .. " "
end

---------------------------------------------------------------------
-- Filetype + position
---------------------------------------------------------------------
local function right_component()
	local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
	local pos = "%l:%c %p%%"

	return "%#SL_Lsp# " .. ft .. "  %#SL_Pos# " .. pos .. " "
end

---------------------------------------------------------------------
-- Render
---------------------------------------------------------------------
function M.render()
	if vim.bo.buftype ~= "" and not vim.bo.modifiable then
		return "%#SL_File# %f %="
	end

	return table.concat({
		mode_component(),
		git_component(),
		file_component(),
		diagnostics_component(),
		lsp_component(),
		"%=",
		right_component(),
	})
end

---------------------------------------------------------------------
-- Global renderer (fast path for statusline eval)
---------------------------------------------------------------------
_G.Statusline_render = function()
	return M.render()
end

---------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------
function M.setup()
	vim.opt.laststatus = 3
	vim.opt.showmode = false
	vim.opt.statusline = "%!v:lua.Statusline_render()"

	local group = vim.api.nvim_create_augroup("NvChadLikeStatusline", { clear = true })

	vim.api.nvim_create_autocmd({
		"ModeChanged",
		"BufEnter",
		"BufWritePost",
		"DiagnosticChanged",
		"LspAttach",
		"LspDetach",
	}, {
		group = group,
		callback = function()
			vim.schedule(function()
				vim.cmd("redrawstatus")
			end)
		end,
	})
end

return M
