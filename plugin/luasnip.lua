local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

vim.keymap.set('i', '<c-j>', function()
    ls.expand_or_jump()
end, { noremap = true })

require("luasnip").add_snippets("go", {
    s("pkg", {
        f(function(_, snip)
            local parts = vim.split(snip.env.TM_DIRECTORY, "/")
            return {
                "package " .. parts[#parts],
                "",
                "",
            }
        end, {}),
    }),
    s("tf", fmt([[
func Test{}(t *testing.T) {{
    for _, s := range []struct{{
        desc string
    }}{{
        {{
            desc: "happy path",
        }},
        {{
            desc: "sad path",
        }},
    }} {{
        s := s
        t.Run(s.desc, func(t *testing.T) {{
            {}
        }})
    }}
}}
]], { i(1, "FunctionName"), i(0) })),
})
