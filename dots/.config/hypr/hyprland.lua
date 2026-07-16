------------------------
---- INTERNAL STUFF ----
------------------------
require("hyprland.lib")
require("hyprland.services")

-------------------
---- AUTOSTART ----
-------------------
require("hyprland.execs")

-----------------
---- GENERAL ----
-----------------
require("hyprland.general")

---------------------------------
---- ENVIRONMENTAL VARIABLES ----
---------------------------------
require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end

---------------------
---- KEYBINDINGS ----
---------------------
require("hyprland.keybinds")

---------------
---- RULES ----
---------------
require("hyprland.rules")

---------------
---- COLORS ----
---------------
require("hyprland.colors")

-----------------------
---- CUSTOM CONFIG ----
-----------------------

if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end

-- Shell overrides --
require("hyprland.shellOverrides.main")

