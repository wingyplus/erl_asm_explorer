--- Convert Erlang filename to Erlang ASM filename.
function asm_filename(erl_fname)
  return string.gsub(erl_fname, "%.erl", ".S")
end

local M = {}

--- Generate Erlang ASM code and display on the next buffer.
function M.asm_explorer()
  local curbufnr = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(curbufnr)

  -- TODO: check erl file.
  -- TODO: checking exit status.

  os.execute(string.format('erlc -S %s', fname))

  -- read Erlang ASM.
  local asm_fname = asm_filename(fname)
  local lines = {}
  local asmfile = io.open(asm_fname, "r")
  for line in asmfile:lines() do
    lines[#lines + 1] = line
  end
  io.close(asmfile)
  os.remove(asm_fname)

  -- load ASM lines into buffer.
  vim.api.nvim_command('vnew')
  local explorer_win = vim.api.nvim_get_current_win()
  local asmbufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(asmbufnr, 'Erlang ASM Explorer')
  vim.api.nvim_buf_set_option(asmbufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_lines(asmbufnr, 0, -1, false, lines)
end

return M
