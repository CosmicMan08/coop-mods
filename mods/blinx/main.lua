-- name: \\#f33e1c\\Blinx The Timesweeper
-- incompatible: moveset
-- description: blinx :3

--blinx
heeyabashSound = audio_sample_load("heeyabash.mp3")
candoublejump = false
hasdoublejumped = false
djmpTimer = 0

--timesweeper
shootTimer = 6

function heeyabash()
	if gPlayerSyncTable[0].blinx == true then
        audio_sample_play(heeyabashSound, gMarioStates[0].pos, 4)
    end
    trashList = {} -- no carrying toads between levels to bring them all together for a big toad jamboree
end

function tablelength(t)
    local count = 0
    for i in pairs(t) do
        count = count + 1
    end
    return count
end

function on_hud_render()
	local m = gMarioStates[0]
    if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil or is_game_paused() or (m.action == ACT_END_PEACH_CUTSCENE or m.action == ACT_CREDITS_CUTSCENE or m.action == ACT_END_WAVING_CUTSCENE) then
        return
    end
	djui_hud_set_resolution(RESOLUTION_N64)
	djui_hud_set_font(FONT_HUD)
	if gPlayerSyncTable[0].blinx == true then
		local size = (djui_hud_get_screen_height() * 0.01)/(m.character.hudHeadTexture.height * 0.15)
		djui_hud_render_texture(get_texture_info("blinxHead"), djui_hud_get_screen_height() / 11, djui_hud_get_screen_height() / 16, size, size)
		--if set_cam_angle(0) == CAM_ANGLE_MARIO then
		--	djui_hud_render_texture(get_texture_info("blinxHead"), djui_hud_get_screen_height() * 1.125, djui_hud_get_screen_height() * 2 / 2.45, size, size)
		--end
        
        local x = 10
        local y = djui_hud_get_screen_height() - 35

        -- set color and render
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("TRASH", x, y - 16, 1)
        djui_hud_print_text(tostring(tablelength(trashList)), x, y, 1)
	end
end

function mario_update(m)
    --double jump code :worried:
    local np = gNetworkPlayers[0]
    if gPlayerSyncTable[0].walgreens then
        np.overrideModelIndex = 3
    else
        np.overrideModelIndex = np.modelIndex
    end
    if gPlayerSyncTable[0].blinx == true and m.playerIndex == 0 then

        --double jump lol
        if (m.action & ACT_FLAG_AIR) ~= 0 and (m.action & ACT_FLAG_RIDING_SHELL) == 0 and m.heldObj == nil then
            candoublejump = true
            djmpTimer = djmpTimer + 1
            --djui_popup_create("bup " .. tostring(candoublejump) .. tostring(hasdoublejumped),1)
        else
            candoublejump = false
            --djui_popup_create("boowomp " .. tostring(candoublejump) .. tostring(hasdoublejumped),1)
        end
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 and (m.action & ACT_FLAG_AIR) == 0 and m.action ~= ACT_HOLD_BUTT_SLIDE then -- landing detection
            djmpTimer = 0
            hasdoublejumped = false
        end
        if candoublejump and (m.input & INPUT_A_PRESSED) ~= 0 and not hasdoublejumped and djmpTimer > 5 then
            set_mario_action(m, ACT_TRIPLE_JUMP, 0)
            m.vel.y = 53
            candoublejump = false
            hasdoublejumped = true
        end
        if hasdoublejumped and (m.action == ACT_TRIPLE_JUMP) then
            function s16(x)
                x = (math.floor(x) & 0xFFFF)
                if x >= 32768 then return x - 65536 end
                return x
            end
            function u16(x)
                x = (math.floor(x) & 0xFFFF)
                if x < 0 then return x + 65536 end
                return x
            end
            local prevPitch = m.faceAngle.x
            local pitchSpeed = (0x1C00 * m.forwardVel) / 60.0
            m.faceAngle.x = s16(m.faceAngle.x + pitchSpeed)
            m.marioObj.header.gfx.angle.x = 0
            set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)
            set_anim_to_frame(m, (m.marioObj.header.gfx.animInfo.curAnim.loopEnd * u16(m.faceAngle.x)) / 0x10000)
        elseif hasdoublejumped then
            m.faceAngle.x = 0
        end
    end

    if m.playerIndex == 0 then
        --sweep sweep sweep
        if sweeper ~= nil then
            if m.health <= 0xff or m.action == ACT_IN_CANNON or m.action == ACT_DISAPPEARED or gPlayerSyncTable[0].blinx == false then
                despawn_sweeper()
                return
            end
            
            if gPlayerSyncTable[0].blinx then
                if shootTimer ~= 6 then
                    shootTimer = shootTimer + 1
                end

                if (m.action & ACT_FLAG_HANGING) == 0 and (m.action & ACT_FLAG_ON_POLE) == 0 and (m.action & ACT_FLAG_SWIMMING_OR_FLYING) == 0 and (m.action & ACT_FLAG_BUTT_OR_STOMACH_SLIDE) == 0 and m.heldObj == nil then
                    if (m.controller.buttonPressed & Y_BUTTON) ~= 0 then
                        shoot_trash()
                    elseif (m.controller.buttonDown & X_BUTTON) ~= 0 and (m.action & ACT_FLAG_AIR) == 0 then
                        suck_trash()
                    end
                else
                    timerSweep = 0
                end
            end
        else
            if m.action ~= ACT_IN_CANNON and m.action ~= ACT_DISAPPEARED and gPlayerSyncTable[0].blinx then
                spawn_sweeper()
            end
        end
    end
end

function on_maction(m)
    --if m.action == ACT_DOUBLE_JUMP then
    --    set_mario_action(m, ACT_JUMP, 0)
    --end
end

function on_sync_valid()
    local m = gMarioStates[0]
    if m.playerIndex == 0 then
        if m.action ~= ACT_IN_CANNON and m.action ~= ACT_DISAPPEARED and gPlayerSyncTable[0].blinx then
            spawn_sweeper()
        end
    end
end

function on_warp()
    despawn_sweeper()
end

hook_event(HOOK_ON_LEVEL_INIT, heeyabash)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_SYNC_VALID, on_sync_valid)
hook_event(HOOK_ON_WARP, on_warp)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_maction)