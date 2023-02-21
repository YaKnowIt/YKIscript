local start_time = util.current_time_millis()
-- code starts here --

-- heist finishes --

-- thanks Verruckt for the auto diamond --
local heist = menu.list(menu.my_root(), "Heists Utilities")
function SET_INT_GLOBAL(global, value)
  memory.write_int(memory.script_global(global), value)
end
function ADD_MP_INDEX(stat)
  if not IS_MPPLY_STAT(stat) then
      stat = "MP" .. util.get_char_slot() .. "_" .. stat
  end
  return stat
end
function STAT_SET_INT(stat, value)
  STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(stat)), value, true)
end
function SET_INT_LOCAL(script, script_local, value)
  if memory.script_local(script, script_local) ~= 0 then
      memory.write_int(memory.script_local(script, script_local), value)
  end
end
menu.action(heist, "[?] Instant finish Casino", {"instacasino"}, "Will instantly finish the Casino Heist.", function()
  menu.trigger_commands("scripthost")
  util.yield_once()
  SET_INT_LOCAL("fm_mission_controller", 19707 + 1741, 151)
  SET_INT_LOCAL("fm_mission_controller", 19707 + 2686, 10000000)
  SET_INT_LOCAL("fm_mission_controller", 27471 + 859, 99999)
  SET_INT_LOCAL("fm_mission_controller", 31585 + 69, 99999)
  SET_INT_LOCAL("fm_mission_controller", 31585 + 97, 79)
end)

-- thanks Verrukt for the auto Cayo Heist --
menu.action(heist, "[?] Instant finish Cayo", {"instacayo"}, "Will instantly finish the Cayo Perico heist.", function()
  menu.trigger_commands("scripthost")
  util.yield_once()

  SET_INT_LOCAL("fm_mission_controller_2020", 42279 + 1, 51338752)
  SET_INT_LOCAL("fm_mission_controller_2020", 42279 + 1375 + 1, 50)
end)

-- thanks Verrukt for the auto Doomsday Heist --
menu.action(heist, "[?] Instant finish Doomsday", {"instadoom"}, "Will instantly finish the Doomsday heist.", function()
  menu.trigger_commands("scripthost")
  util.yield_once()

  SET_INT_LOCAL("fm_mission_controller", 19707, 12)
  SET_INT_LOCAL("fm_mission_controller", 28329 + 1, 99999)
  SET_INT_LOCAL("fm_mission_controller", 31585 + 69, 99999)
end)

--displays and logs--

local displaylog = menu.list(menu.my_root(), "Displays and Logs")
-- displays and logs languages of players --
menu.action(displaylog, "Toast Everyones Language", {"toastlang"}, "Players language will be toasted and logged.", function()
  for i = 0, 31 do
    local player_id = i
    local player_name = players.get_name(player_id)
    local player_language = players.get_language(player_id)
      util.toast(player_name .. " has joined the game with language: " .. player_language, 1)
      util.log(player_name .. " has joined the game with language: " .. player_language, 1)
  end
end)

-- displays and logs player flags --
menu.action(displaylog, "Toast Everyones Flags", {"toastflags"}, "If a player in the session has any flags, they will be toasted and logged", function()
  for i = 0, 31 do
      local player_id = i
      local player_name = players.get_name(player_id)
      local player_tags = players.get_tags_string(player_id)
      if player_tags ~= "" then
        util.toast(player_name .. " has tags: " .. player_tags, 1)
        util.log(player_name .. " has tags: " .. player_tags, 1)
      end
    end
  end)

-- displays and logs who is in godmode --
menu.action(displaylog, "Toast Godmode", {"toastgodmode"}, "Toast Godmode players", function()
  local function main()
      for i = 0, 31 do
        if players.is_godmode(i) then
          local player_name = players.get_name(i)
          util.toast(player_name .. " is in godmode", 1)
          util.log(player_name .. " is in godmode", 1)
        end
      end
    end

    main()
      end, true)

-- Code ends here --
local end_time = util.current_time_millis()
local load_time = end_time - start_time

util.toast("Script loaded in " .. load_time .. "ms", TOAST_ALL)