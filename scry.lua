-- luacheck: globals request

-- $ luarocks install lcf
-- $ luarocks install luacheck

local luacheck = require "luacheck"

-- declares a global "request" function, based on "require" that
-- supports relative imports; note that this does add some spam
-- to `_G` (dependencies, get_require_name and some functions).
require("lcf.workshop.base")

local function read()
  local lines = {}
  for line in io.lines() do
    table.insert(lines, line)
  end
  return table.concat(lines, "\n")
end

local function check(source)
  local report = luacheck.check_strings({source}, {})

  local out = {}
  for _, v in ipairs(report) do
    for _, issue in ipairs(v) do
      table.insert(
        out,
        string.format(
          [[
    {
      "code": "%s",
      "line": %d,
      "column": %d,
      "end_column": %d,
      "name": "%s",
      "msg": %s
    }]],
          issue.code,
          issue.line,
          issue.column,
          issue.end_column,
          issue.name or "",
          string.format("%q", luacheck.get_message(issue))
        )
      )
    end
  end
  print('{\n  "issues": [\n' .. table.concat(out, ",\n") .. "\n  ]\n}")
end

local function format(source)
  local get_ast = request("!.lua.code.get_ast")
  local get_formatted_code = request("!.lua.code.ast_as_code")
  local formatted =
    get_formatted_code(
    get_ast(source),
    {
      indent_chunk = "  ",
      right_margin = 96, -- ?
      max_text_width = math.huge,
      keep_unparsed_tail = true,
      keep_comments = true
    }
  )

  local lines = {}
  for line in formatted:gmatch("[^\n]+") do
    table.insert(lines, string.format("%q", line))
  end

  print('{\n  "source" :\n [\n' .. table.concat(lines, ",\n") .. "\n  ]\n}")
end

local function run(cmd)
  if (cmd == "--advise") then
    check(read())
  elseif (cmd == "--mend") then
    format(read())
  else
    print("unrecognized command: "..cmd)
  end
end

run(arg[1])
