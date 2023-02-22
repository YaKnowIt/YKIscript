-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end
auto_updater.run_auto_update({
    check_interval= 1,
    source_url="https://raw.githubusercontent.com/YaKnowIt/YKIscript/main/YKIscript.lua",
    script_relpath=SCRIPT_RELPATH,
    verify_file_begins_with="--"
})
local start_time = util.current_time_millis()
local change = menu.list(menu.my_root(), "Changelog")
local heist = menu.list(menu.my_root(), "Heist Utilities")
local displaylog = menu.list(menu.my_root(), "Displays and Logs")
local propertytp = menu.list(menu.my_root(), "Property Teleports")
-- code starts here --
-- restart script button --
menu.action(menu.my_root(), 'Restart Script', {}, 'Restarts the script to check for updates', function ()
  util.restart_script()
end)
-- credit JerryScript --
util.toast("Welcome to YKIscript. Version 1.4 coded for GTA:O version 1.66")
util.yield(100)
util.toast("Scanning GTA Version...")
util.yield(500)
local addr = memory.scan("4C 8D 05 ? ? ? ? 48 8D 15 ? ? ? ? 48 8B C8 E8 ? ? ? ? 48 8D 15 ? ? ? ? 48 8D 4C 24 20 E8")
if addr == 0 then
    util.toast("pattern scan failed")
else
    util.toast(memory.read_string(memory.rip(addr + 3)))
end
util.require_natives('1660775568-uno')
local nativeNameSpaces = {
  'HUD',
}
--credit to scriptCat (^-^)
local function get_waypoint_v3()
  if HUD.IS_WAYPOINT_ACTIVE() then
      local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
      local waypoint_pos = HUD.GET_BLIP_COORDS(blip)

      local success, Zcoord = util.get_ground_z(waypoint_pos.x, waypoint_pos.y)
      local tries = 0
      while not success or tries <= 100 do
          success, Zcoord = util.get_ground_z(waypoint_pos.x, waypoint_pos.y)
          tries += 1
          util.yield_once()
      end
      if success then
          waypoint_pos.z = Zcoord
      end

      return waypoint_pos
  else
      util.toast('No waypoint set.')
  end
end
-- heist finishes --
-- thanks Verruckt for the auto diamond --
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


menu.action(change, "[1.1] First Version, 3 Heist Scripts and 3 Display and Log Scripts.", {""}, "", function()
end, true)
menu.action(change, "[1.2] Added Restart Button", {""}, "", function()
end, true)
menu.action(change, "[1.3] Added Welcome Message", {""}, "", function()
end, true)
menu.action(change, "[1.4] Changed Welcome Message and Added PropertyTP", {""}, "", function()
end, true)


-- property tp from JerryScript --
local propertyBlips = {
  [1] = { name = ('Ceo office'),   sprite = 475 },
  [2] = { name = ('MC clubhouse'), sprite = 492,
      subProperties = {listName = ('MC businesses'), properties = {
          [1] = { name = ('Weed farm'),           sprite = 496 },
          [2] = { name = ('Cocaine lockup'),      sprite = 497 },
          [3] = { name = ('Document forgery'),    sprite = 498 },
          [4] = { name = ('Methamphetamine Lab'), sprite = 499 },
          [5] = { name = ('Counterfeit cash'),    sprite = 500 },
      }}
  },
  [3] = { name = ('Bunker'),     sprite = 557 },
  [4] = { name = ('Hangar'),     sprite = 569 },
  [5] = { name = ('Facility'),   sprite = 590 },
  [6] = { name = ('Night club'), sprite = 614 },
  [7] = { name = ('Arcade'),     sprite = 740 },
  [8] = { name = ('Auto shop'),  sprite = 779 },
  [9] = { name = ('Agency'),     sprite = 826 },
}

local function getUserPropertyBlip(sprite)
  local blip = HUD.GET_FIRST_BLIP_INFO_ID(sprite)
  while blip ~= 0 do
      local blipColour = HUD.GET_BLIP_COLOUR(blip)
      if HUD.DOES_BLIP_EXIST(blip) and blipColour != 55 and blipColour != 3 then return blip end
      blip = HUD.GET_NEXT_BLIP_INFO_ID(sprite)
  end
end

local function tpToBlip(blip)
  local pos = HUD.GET_BLIP_COORDS(blip)
  local tpEntity = (PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and my_cur_car or players.user_ped())
  ENTITY.SET_ENTITY_COORDS(tpEntity, pos, false, false, false, false)
end

local propertyTpRefs = {}
local function regenerateTpLocations(root)
  for k, _ in pairs(propertyTpRefs) do
      menu.delete(propertyTpRefs[k])
      propertyTpRefs[k] = nil
  end
  for i = 1, #propertyBlips do
      local propertyBlip = getUserPropertyBlip(propertyBlips[i].sprite)
      if propertyBlip == nil then continue end

      propertyTpRefs[propertyBlips[i].name] = menu.action(propertytp, propertyBlips[i].name, {}, '', function()
          if not HUD.DOES_BLIP_EXIST(propertyBlip) then
              util.toast('Couldn\'t find property.')
              return
          end
          tpToBlip(propertyBlip)
      end)
      if propertyBlips[i].subProperties then
          local subProperties = propertyBlips[i].subProperties
          local listName = subProperties.listName
          propertyTpRefs[listName] = menu.list(propertytp, listName, {}, '')
          for j = 1, #subProperties.properties do
              local subPropertyBlip = getUserPropertyBlip(subProperties.properties[j].sprite)
              if propertyBlip == nil then continue end

              menu.action(propertyTpRefs[listName], subProperties.properties[j].name, {}, '', function() --no need to have refs to these because they get deleted with the sublist
                  if not HUD.DOES_BLIP_EXIST(propertyBlip) then
                      util.toast('Couldn\'t find property.')
                      return
                  end
                  tpToBlip(subPropertyBlip)
              end)
          end
      end
  end
end

menu.action(propertytp, "Property Teleports", {""}, "", function()
  regenerateTpLocations('Property tp\'s')
end)

-- Code ends here --
local end_time = util.current_time_millis()
local load_time = end_time - start_time

util.toast("Script loaded in " .. load_time .. "ms", TOAST_ALL)
