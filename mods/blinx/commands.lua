E_MODEL_BLINX = smlua_model_util_get_id("blinx_geo")
E_MODEL_BLINXSWEEPED = smlua_model_util_get_id("blinxsweeped_geo")
E_MODEL_BLINXINVERTED = smlua_model_util_get_id("blinxinverted_geo")
E_MODEL_BLINXSWEEPEDINVERTED = smlua_model_util_get_id("blinxsweepedinverted_geo")


function on_blinx_command(msg)
    if msg == "off" then
        gPlayerSyncTable[0].modelId = nil
        gPlayerSyncTable[0].blinx = false
    else
        gPlayerSyncTable[0].modelId = E_MODEL_BLINX
        gPlayerSyncTable[0].blinx = true
        gPlayerSyncTable[0].walgreens = true
        gPlayerSyncTable[0].invert = false
        djui_chat_message_create("Mario, Sonic... Prepare for war.")
        spawn_sweeper()
    end
    return true
end

function on_invert_command(msg)
    gPlayerSyncTable[0].invert = not gPlayerSyncTable[0].invert
    return true
end

function cosmic_check(m)
    if gNetworkPlayers[0].name == "CosmicMan08" then
        gPlayerSyncTable[0].modelId = E_MODEL_BLINX
        gPlayerSyncTable[0].blinx = true
        gPlayerSyncTable[0].walgreens = true
        gPlayerSyncTable[0].invert = false
        djui_chat_message_create("Mario, Sonic... Prepare for war.")
        spawn_sweeper()
    end
end

function mario_update(m)
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, cosmic_check)
hook_chat_command("blinx", "[on|off|invert] blinx", on_blinx_command)
hook_chat_command("invert", "Reverses the colors.", on_invert_command)