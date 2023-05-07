-- name: CRIMSON
-- incompatible:
-- description: (stands for "Cosmic's Really Idiotic Mario Sixtyf Our Nchallenges")

--some toggles
releasioEnabled = false
goombEnabled = false
diveEnabled = false
APressEnabled = false
BackEnabled = false
DieEnabled = false
demonEnabled = false
onlyUpEnabled = false
spookEnabled = false
walkingEnabled = false
pauseEnabled = false

--other variables
waterDiveTimer = 60
pauseTimer = 0

function auto()
    if goombEnabled then -- goomb
        goombx = math.random(-8200,8200)
        goombz = math.random(-8200,8200)
        goomby = find_floor_height(goombx, math.random(-8200,8200), goombz) -- no sky goombas, sry
        if goomby > 50 then -- spawns a goomba if it's not on the death barrier, doesn't always work but ¯\_(ツ)_/¯
            spawn_sync_object(
                id_bhvGoomba,
                E_MODEL_GOOMBA,
                goombx, goomby, goombz,
                nil
            )
        end
    end
end

function grendemone(obj)
    if demonEnabled then -- gren dmeon!
        nearest = nearest_mario_state_to_object(obj)
        if (((get_id_from_behavior(obj.behavior) == id_bhvHidden1up) or (get_id_from_behavior(obj.behavior) == id_bhvHidden1upInPole)) and nearest.playerIndex == 0) then
            gMarioStates[0].health = 0
        end
    end
end

function coyndemone(m,obj,intereacitoan)
    nuts = true
    if demonEnabled then -- coyn dmeon!
        if intereacitoan == (1 << 4) then
            m.health = m.health - 256
            nuts = false
            obj_mark_for_deletion(obj)
        end
    end
    return nuts
end

function mauto_the_prequel(m)
    if onlyUpEnabled then
        m.controller.stickX = 0
        m.controller.stickY = math.abs(m.controller.stickY)
        m.controller.rawStickX = 0
        m.controller.rawStickY = math.abs(m.controller.rawStickY)
    end

    if walkingEnabled then
        m.controller.buttonPressed = 1
        m.controller.buttonDown = 1
    end

    --oldMinput = m.input
    --djui_popup_create(tostring(m.controller.buttonDown .. " " .. m.controller.buttonPressed .. " " .. m.input), 1)
    if APressEnabled then
        m.controller.buttonPressed = m.controller.buttonPressed | A_BUTTON
        m.controller.buttonDown = m.controller.buttonDown | A_BUTTON
        --m.input = m.input | INPUT_A_PRESSED
    end
    if pauseEnabled then
        pauseTimer = pauseTimer + 1
        if pauseTimer > math.random(50,500) then
            m.controller.buttonPressed = m.controller.buttonPressed | 4096
            pauseTimer = 0
        end
        --m.input = m.input | INPUT_A_PRESSED
    end
    --djui_popup_create(tostring(oldMinput .. " " .. m.input),2)
end

function mauto(m)
    --deez
end

function mario_physicnt(m)
    if releasioEnabled then -- releasio
        -- code by Piko Piko/Amy Rose
        play_sound(SOUND_MENU_STAR_SOUND_LETS_A_GO, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        play_character_sound(m, CHAR_SOUND_WAAAOOOW)

        -- does weird stuff to your speed
        if (m.controller.buttonDown & B_BUTTON) ~= 0 or (m.controller.buttonDown & Z_TRIG) ~= 0 then
            play_character_sound(m, CHAR_SOUND_WAAAOOOW)
            m.forwardVel = -4000
        elseif m.forwardVel > 15 then
            play_character_sound(m, CHAR_SOUND_WAAAOOOW)
            m.forwardVel = 200
        end
        if BackEnabled then
            m.forwardVel = 0-m.forwardVel
        end
    end
    
    if (DieEnabled) and (m.health<2176) then -- die
        m.health = 0
    end

    if diveEnabled then
        if (m.input & INPUT_A_PRESSED) ~= 0 then
            if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
                set_mario_action(m, ACT_DIVE, 0)
            end
            waterDiveTimer=60
            mario_set_forward_vel(m, 48)
        end
        if (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED then
            if waterDiveTimer > 0 then
                set_mario_animation(m, MARIO_ANIM_DIVE)
            end
        end
        waterDiveTimer = waterDiveTimer - 1
    end
    
    --djui_popup_create(tostring(m.forwardVel),1)
    if BackEnabled then
        m.forwardVel = -math.abs(m.forwardVel)
    end
end

--command stuff
function on_releasio(msg)
    releasioEnabled = (msg == "on")
end
function on_goomb(msg)
    goombEnabled = (msg == "on")
end
function on_dive(msg)
    diveEnabled = (msg == "on")
end
function on_a(msg)
    APressEnabled = (msg == "on")
end
function on_back(msg)
    BackEnabled = (msg == "on")
end
function on_die(msg)
    DieEnabled = (msg == "on")
end
function on_demon(msg)
    demonEnabled = (msg == "on")
end
function on_onlyup(msg)
    onlyUpEnabled = (msg == "on")
end
function on_walk(msg)
    walkingEnabled = (msg == "on")
end
function on_pause(msg)
    pauseEnabled = (msg == "on")
end
function on_hell(msg)
    releasioEnabled = (msg == "on")
    goombEnabled = (msg == "on")
    diveEnabled = (msg == "on")
    APressEnabled = (msg == "on")
    BackEnabled = (msg == "on")
    DieEnabled = (msg == "on")
    demonEnabled = (msg == "on")
    onlyUpEnabled = (msg == "on")
    walkingEnabled = (msg == "on")
    pauseEnabled = (msg == "on")
end

hook_chat_command("releasio", "[on|off] Releasio physics", on_releasio)
hook_chat_command("goombas", "[on|off] Spawns goombas everywhere", on_goomb)
hook_chat_command("dive", "[on|off] Makes you dive forward everytime you press the A button", on_dive)
hook_chat_command("a", "[on|off] Initiates a full A-press every frame", on_a)
hook_chat_command("goback", "[on|off] All velocity is backwards", on_back)
hook_chat_command("justdontdieez", "[on|off] You have 1 hit point", on_die)
hook_chat_command("demon", "[on|off] 1 ups kill you and coins damage you", on_demon)
hook_chat_command("onlyup", "[on|off] You can only hold up on the joystick", on_onlyup)
hook_chat_command("walking", "[on|off] Disables every button. you may only walk", on_walk)
hook_chat_command("pause", "[on|off] Initiates a pause at random times :))))))))", on_pause)
hook_chat_command("hell", "[on|off] Toggles every effect at once.", on_hell)

hook_event(HOOK_UPDATE, auto)
hook_event(HOOK_MARIO_UPDATE, mauto)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_physicnt)
hook_event(HOOK_BEFORE_MARIO_UPDATE, mauto_the_prequel)
hook_event(HOOK_ON_OBJECT_UNLOAD, grendemone)
hook_event(HOOK_ALLOW_INTERACT, coyndemone)